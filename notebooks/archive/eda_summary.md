# Exploratory Data Analysis Summary

**Notebook:** `notebooks/02_exploratory_analysis.ipynb`
**Dataset:** `data/supply_chain_cleaned.csv` (180,519 rows × 62 columns)

---

## Core KPIs

| Metric | Value |
|--------|-------|
| On-Time Delivery Rate | **42.7%** |
| Late Delivery Rate | **57.3%** |
| Average Shipping Delay | 0.55 days |
| Worst-case Delay | 2 days |
| Total Sales | **$36,784,735** |
| Total Profit | **$5,929,486** |

---

## Hypothesis Results

| # | Hypothesis | Result |
|---|-----------|--------|
| **H1** | Expedited shipping has lower late delivery risk | **Rejected** — Standard Class (60.2% on-time) outperforms First Class (0.0%) |
| **H4** | Late deliveries correlate with lower margins | **Not confirmed** — On-Time avg profit $33.08 vs Late $32.67 (negligible difference) |
| **H5** | Order volume peaks seasonally in Q4 | **Not confirmed** — Q1 ($9.47M) highest, Q4 ($8.47M) lowest |

---

## Shipping Mode Performance (H1)

| Mode | Orders | Late Rate | Avg Delay |
|------|--------|-----------|-----------|
| First Class | 27,814 | **100.0%** | 1.00 days |
| Second Class | 35,216 | 79.7% | 1.59 days |
| Same Day | 9,737 | 47.8% | 0.48 days |
| Standard Class | 107,752 | **39.8%** | 0.10 days |

Standard Class is both the most used (59.7% of orders) and the most reliable.

---

## Profit by Delivery Status (H4)

| Status | Avg Profit | Median Profit | Orders |
|--------|-----------|---------------|--------|
| On-Time | **$33.08** | $31.68 | 77,119 |
| Late | **$32.67** | $31.43 | 103,400 |

The difference ($0.41) is negligible. Late deliveries do not significantly impact per-order profitability.

---

## Seasonality (H5)

| Quarter | Total Sales | % of Total |
|---------|-------------|------------|
| Q1 | **$9,472,446** | 25.7% |
| Q2 | $9,298,513 | 25.3% |
| Q3 | $9,539,713 | 25.9% |
| Q4 | $8,474,064 | **23.0%** |

There is **no Q4 peak**. Demand is relatively stable year-round with a slight dip in November–December. Monthly orders range from 12,500–17,979.

---

## Top Correlations

| Feature 1 | Feature 2 | Correlation |
|-----------|-----------|-------------|
| `order_profit_per_order` | `benefit_per_order` | 1.00 |
| `order_to_shipping_hours` | `days_for_shipping_real` | 1.00 |
| `order_item_total` | `sales` | 0.99 |
| `is_early_or_ontime` | `late_delivery_risk` | −0.95 |
| `order_item_total` | `sales_per_customer` | 0.93 |

---

## Top Categories, Products & Regions

**Top Categories by Sales:**
1. Fishing ($6.9M)
2. Cleats ($4.4M)
3. Camping & Hiking ($4.1M)
4. Cardio Equipment ($3.7M)
5. Women's Apparel ($3.1M)

**Top Markets:**
- USCA (US & Canada) — highest volume
- Pacific Asia — second highest
- Europe, Africa, LATAM following

---

## Visual Assets

| File | Description |
|------|-------------|
| `visuals/01_numeric_distributions.png` | Distribution of 6 key numeric features |
| `visuals/02_ontime_vs_late.png` | On-Time 42.7% vs Late 57.3% bar chart |
| `visuals/03_correlation_heatmap.png` | Full numeric correlation matrix |
| `visuals/04_late_rate_by_mode.png` | Late rate by shipping mode (H1) |
| `visuals/05_monthly_trend.png` | Monthly order volume & sales trend (H5) |
| `visuals/06_seasonality.png` | Quarterly sales & weekday order count |
| `visuals/07_profit_by_delivery_status.png` | Boxplot: On-Time vs Late profit (H4) |
| `visuals/08_top_*.png` | Top categories, products, regions, markets |

---

## Key Takeaways

1. **Only 42.7% of orders arrive on-time** — significant room for logistics improvement
2. **Standard Class is the best shipping mode** — highest on-time rate, lowest cost
3. **Profit is not impacted by late delivery** — the financial penalty is absorbed elsewhere in the supply chain
4. **No seasonal Q4 peak** — demand is stable; capacity planning should be level year-round
5. **Fishing ($6.9M) and Cleats ($4.4M)** are the highest-value categories to prioritize
