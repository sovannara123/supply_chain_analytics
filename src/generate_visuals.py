import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import psycopg2
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Setup style (clean, no chartjunk, perceptual colors)
plt.style.use('seaborn-v0_8-whitegrid')
sns.set_context("talk", font_scale=0.9)
plt.rcParams['axes.spines.top'] = False
plt.rcParams['axes.spines.right'] = False
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.edgecolor'] = '#333333'

# DB Connection
conn = psycopg2.connect(
    host=os.getenv("DB_HOST", "localhost"),
    port=os.getenv("DB_PORT", "5432"),
    user=os.getenv("DB_USER", "analyst_user"),
    password=os.getenv("DB_PASSWORD", "analyst_user"),
    dbname=os.getenv("DB_NAME", "supply_chain")
)

output_dir = 'visuals'
os.makedirs(output_dir, exist_ok=True)

# ---------------------------------------------------------
# Chart 1: Shipping Mode vs Late Rate
# ---------------------------------------------------------
df_modes = pd.read_sql_query("""
    SELECT 
        shipping_mode, 
        ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) as late_rate_pct 
    FROM fact_order_items 
    GROUP BY shipping_mode 
    ORDER BY late_rate_pct ASC
""", conn)

fig, ax = plt.subplots(figsize=(10, 5))
colors = ['#E15759' if x in ['Standard Class', 'First Class'] else '#B0B0B0' for x in df_modes['shipping_mode']]
bars = ax.barh(df_modes['shipping_mode'], df_modes['late_rate_pct'], color=colors)

ax.set_xlim(0, 100)
ax.set_xlabel('Late Delivery Rate (%)', weight='bold')
ax.set_title('Standard & First Class Driving the Late Deliveries', weight='bold', loc='left', pad=15)

for bar in bars:
    width = bar.get_width()
    ax.text(width + 1, bar.get_y() + bar.get_height()/2, f'{width}%', 
            va='center', ha='left', weight='bold', color='#333333')

plt.tight_layout()
plt.savefig(f'{output_dir}/shipping_modes.png', dpi=300)
plt.close()

# ---------------------------------------------------------
# Chart 2: Top 10 Origin Cities for Late Orders
# ---------------------------------------------------------
df_cities = pd.read_sql_query("""
    SELECT 
        order_city, 
        COUNT(*) as total_late_orders,
        ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) as late_rate_pct
    FROM fact_order_items 
    WHERE late_delivery_risk = 1
    GROUP BY order_city 
    ORDER BY total_late_orders DESC 
    LIMIT 10
""", conn)
df_cities = df_cities.sort_values('total_late_orders', ascending=True)

fig, ax = plt.subplots(figsize=(10, 6))
bars = ax.barh(df_cities['order_city'], df_cities['total_late_orders'], color='#F28E2B')

ax.set_xlabel('Volume of Late Orders', weight='bold')
ax.set_title('Top 10 Worst Origin Cities (By Late Volume)', weight='bold', loc='left', pad=15)

for bar in bars:
    width = bar.get_width()
    ax.text(width + 100, bar.get_y() + bar.get_height()/2, f'{int(width):,}', 
            va='center', ha='left', weight='bold', color='#333333')

plt.tight_layout()
plt.savefig(f'{output_dir}/worst_cities.png', dpi=300)
plt.close()

# ---------------------------------------------------------
# Chart 3: Flat Late Rate Year-Round
# ---------------------------------------------------------
df_trend = pd.read_sql_query("""
    SELECT 
        EXTRACT(YEAR FROM order_date) as year, 
        EXTRACT(MONTH FROM order_date) as month, 
        ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) as late_rate_pct
    FROM fact_order_items 
    GROUP BY year, month 
    ORDER BY year, month
""", conn)

# Create a date string for plotting
df_trend['date'] = pd.to_datetime(df_trend['year'].astype(int).astype(str) + '-' + df_trend['month'].astype(int).astype(str).str.zfill(2) + '-01')

fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(df_trend['date'], df_trend['late_rate_pct'], marker='o', linestyle='-', color='#4E79A7', linewidth=2, markersize=5)

ax.set_ylim(0, 100) # Perceptually honest baseline
ax.axhline(y=df_trend['late_rate_pct'].mean(), color='#E15759', linestyle='--', linewidth=1.5, alpha=0.7, label='Average (54.8%)')
ax.set_ylabel('Late Delivery Rate (%)', weight='bold')
ax.set_title('Structural Problem: Late Rates are Flat Year-Round (~55%)', weight='bold', loc='left', pad=15)
ax.legend(frameon=False)

plt.tight_layout()
plt.savefig(f'{output_dir}/seasonal_trend.png', dpi=300)
plt.close()

# ---------------------------------------------------------
# Chart 4: ROI Projection
# ---------------------------------------------------------
scenarios = ['Fix worst 20% of origins', 'Fix Standard Class to Second Class levels', '1 truck pilot on Phnom Penh–Siem Reap']
profit = [1700000, 462000, 0]

fig, ax = plt.subplots(figsize=(10, 4))
# Reverse to have the highest on top
scenarios.reverse()
profit.reverse()

colors = ['#B0B0B0' if p == 0 else '#59A14F' for p in profit]
bars = ax.barh(scenarios, profit, color=colors)

ax.set_xlabel('Estimated Profit Protected ($ USD)', weight='bold')
ax.set_title('Potential ROI by Addressing the Road Bottleneck', weight='bold', loc='left', pad=15)
ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, p: format(int(x), ',')))

for bar, p in zip(bars, profit):
    width = bar.get_width()
    if p > 0:
        label = f'${p/1000000:.1f}M' if p >= 1000000 else f'${p/1000:.0f}K'
        ax.text(width + 20000, bar.get_y() + bar.get_height()/2, label, 
                va='center', ha='left', weight='bold', color='#333333')
    else:
        ax.text(width + 20000, bar.get_y() + bar.get_height()/2, 'TBD (Pilot)', 
                va='center', ha='left', weight='bold', color='#B0B0B0')

plt.tight_layout()
plt.savefig(f'{output_dir}/roi_projection.png', dpi=300)
plt.close()

print("Visuals generated successfully in reports/visuals/")
