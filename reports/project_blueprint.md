# Project Blueprint — Mekong Distribution Late Delivery Analysis

## 1. Business Snapshot

| Field | Detail |
|-------|--------|
| **Company** | Mekong Distribution Co., Ltd., Phnom Penh |
| **Business** | Imports consumer goods from Vietnam, Thailand, China; distributes to ~800 retail partners across Cambodia |
| **Revenue** | ~$8M/year |
| **Employees** | ~120 |
| **Problem** | 57% of deliveries arrive late. Retailers are complaining. Some have started buying from competitors. |
| **Stakeholder** | Operations Director |
| **Decision** | Buy 2 delivery trucks ($80K) OR upgrade warehouse racking/inventory system ($60K). Budget covers only one. |
| **Deadline** | 3 weeks |
| **Recommendation** | Enforce SLAs and diversify carriers. Do not spend CapEx on trucks or warehouse. |
| **Data source** | DataCo Smart Supply Chain dataset (Kaggle). 180,519 orders, 2015–2018. |

---

## 2. Data Flow Map

```
Kaggle CSV (DataCoSupplyChainDataset.csv)
        │
        ▼
PostgreSQL (datacosupplychaindataset table)
        │
        ▼
analysis_ready view ────────────────────────────────────────────────┐
    (24 curated columns, computed delay + on-time flags)            │
        │                                                          │
        ├── sql/01_supply_chain_kpis.sql ◄── Executive metrics     │
        ├── sql/02_shipping_and_routes.sql ◄── Route performance   │
        ├── sql/04_data_quality_check.sql ◄── Data validation      │
        │                                                          │
        ├── notebooks/01_cleaning_and_exploration.ipynb            │
        │       │                                                  │
        │       ├── Cleans data, handles missing values            │
        │       ├── Discovers 57% late rate                       │
        │       ├── Flags First Class data artifact               │
        │       └── Generates: ontime_vs_late.png                 │
        │                     late_rate_by_mode.png                 │
        │                     profit_by_delivery_status.png         │
        │                     top_category_name.png                 │
        │                     top_market.png                        │
        │                     top_order_region.png                  │
        │                     top_product_name.png                  │
        │                                                          │
        └── notebooks/02_root_cause_analysis.ipynb                 │
                │                                                  │
                ├── Shipping mode comparison (Standard vs Second)  │
                ├── Pareto analysis: 20% origins → 71% late       │
                ├── Seasonality check (flat year-round)           │
                ├── What-if simulation                            │
                ├── Statistical test (Welch t-test on profit)     │
                └── Generates: rca_late_rate_by_mode.png           │
                              rca_region_heatmap.png                │
                              rca_pareto.png                        │
                              rca_monthly_trend.png                 │
                              rca_customer_segment.png               │

Shared module:
    src/utils.py ◄── setup_plotting(), save_fig()
    (used by both notebooks)

Reports:
    reports/executive_summary.md  ◄── 1-page for Operations Director
    reports/project_overview.md   ◄── Full stakeholder-facing overview
    reports/project_blueprint.md  ◄── This document
```

---

## 3. File-by-File Reference

### SQL (4 files)

| File | Purpose | Key Output |
|------|---------|-----------|
| `sql/00_create_table.sql` | Creates PostgreSQL table + indexes + `analysis_ready` view | Database schema, computed delay column, on-time flag |
| `sql/01_supply_chain_kpis.sql` | Executive KPIs: OTD rate, lead times, profit comparison, order status breakdown | 6 queries with window functions |
| `sql/02_shipping_and_routes.sql` | Shipping mode performance, market × region heatmap data, origin city ranking | 6 queries with CTEs, multi-level aggregation |
| `sql/04_data_quality_check.sql` | Row counts, null checks, duplicates, date integrity, negative values | 11 data quality checks |

### Notebooks (2 files)

| File | Cells | Purpose |
|------|-------|---------|
| `notebooks/01_cleaning_and_exploration.ipynb` | ~20 cells | Load from DB, clean, handle missing values, EDA, initial discovery of 57% late rate, First Class artifact flagging |
| `notebooks/02_root_cause_analysis.ipynb` | ~30 cells | Shipping mode comparison, Pareto analysis, monthly trend, what-if simulation, Welch t-test, recommendation |

### Python (2 files)

| File | Purpose | Functions |
|------|---------|-----------|
| `src/__init__.py` | Package marker | — |
| `src/utils.py` | Shared utilities | `setup_plotting()` — configures seaborn/matplotlib styles. `save_fig(name)` — saves plot to `visuals/` directory with consistent settings. |

### Reports (3 files)

| File | Audience | Length | Purpose |
|------|----------|--------|---------|
| `reports/executive_summary.md` | Operations Director | 1 page | Problem → finding → recommendation → action plan. No code. |
| `reports/project_overview.md` | Stakeholders / hiring managers | Full | Company context, data, analysis pipeline, findings, recommendation, open questions |
| `reports/project_blueprint.md` | Developers / yourself | Full | This document — how everything connects |

### Config (2 files)

| File | Purpose |
|------|---------|
| `.env.example` | Template for database connection credentials. Copy to `.env` and fill in. |
| `.gitignore` | Excludes CSV data files (293MB), `.env`, Python cache, venv |

### Visuals (12 files)

| File | Source Notebook | What It Shows |
|------|----------------|---------------|
| `ontime_vs_late.png` | 01_cleaning | Bar chart: 57% late vs 43% on-time |
| `late_rate_by_mode.png` | 01_cleaning | Late rate across Standard, Second, First Class |
| `profit_by_delivery_status.png` | 01_cleaning | Box plot: profit per order on-time vs late |
| `top_category_name.png` | 01_cleaning | Top 10 categories by sales |
| `top_market.png` | 01_cleaning | Top 10 markets by sales |
| `top_order_region.png` | 01_cleaning | Top 10 regions by sales |
| `top_product_name.png` | 01_cleaning | Top 10 products by sales |
| `rca_late_rate_by_mode.png` | 02_root_cause | Late rate by mode with color coding (>50% = red) |
| `rca_region_heatmap.png` | 02_root_cause | Market × Region heatmap of on-time rates |
| `rca_pareto.png` | 02_root_cause | Pareto chart: 20% origins → 71% late orders |
| `rca_monthly_trend.png` | 02_root_cause | Monthly late rate line chart (flat 55% for 4 years) |
| `rca_customer_segment.png` | 02_root_cause | Late rate by customer segment (Consumer, Corporate) |

---

## 4. Analysis Pipeline (Step-by-Step)

### Step 1: Data Loading & Cleaning (notebook 01)
- Load 180,519 orders from PostgreSQL `analysis_ready` view
- Drop columns with >50% missing values (none found)
- Fill categorical NaNs with 'Unknown'
- Fill numeric NaNs with median (<1% missing, minimal impact)
- Feature engineering: order year, month, day, hour, quarter, season, weekend flag
- IQR outlier capping on 7 numeric columns (noted: too aggressive on `actual_shipping_delay` at 19.8%)
- **Discovery: 54.8% late delivery rate**

### Step 2: Exploratory Analysis (notebook 01)
- On-time vs late bar chart
- Late rate by shipping mode (Standard 60.2%, Second 46.7%)
- **Flagged: First Class data is an artifact** (all 27K orders have identical 1-day-scheduled/2-day-real shipping)
- Profit by delivery status ($33 on-time vs $32 late — negligible difference)
- Top categories, products, regions, markets by sales

### Step 3: Root Cause Analysis (notebook 02)
- **Shipping modes:** Standard Class (60% of volume) has 60.2% late rate vs Second Class at 46.7%. Same warehouse, different late rates → problem is on the road.
- **Geographic analysis:** Central Africa (60.7% late) and Pacific Asia (59.7%) worst. Canada best (48.1%).
- **Pareto analysis:** 20% of origin cities → 71% of late orders. Concentration confirms route-specific issue.
- **Seasonality check:** Late rate flat at 54-55% every month for 4 years. No rainy season or Q4 spike.
- **Profit t-test:** Welch's independent t-test. Late vs on-time profit difference: p = 0.11 (not significant). Effect is <$1 per order.
- **ABC classification:** 6 A-items drive 70% of revenue. Fan Shop is most profitable department ($2.9M).
- **What-if simulation:** Shifting 25% of Standard to Second Class eliminates ~3,300 late orders.

### Step 4: Recommendation (notebook 02)
- **Decision:** Shift to Asset-Light Strategy. Enforce SLAs on 3PLs and cancel fleet CapEx purchase
- **Don't upgrade the warehouse** — evidence points to 3PL transit bottleneck, not picking/packing
- **Next:** Audit carrier records and issue RFP for secondary carriers on the worst Standard Class routes

---

## 5. Key Findings — Why They Matter

| Finding | Evidence | Business Action | Tells Us… |
|---------|----------|----------------|-----------|
| 57% of deliveries are late | 180K orders, 4 years, flat trend | This is systemic, not fixable with quick fixes | Operations need structural change |
| Standard 60% late vs Second 47% late | Same warehouse, same products | Focus carrier management, not warehouse | The bottleneck is on the road |
| 20% of origins → 71% of late orders | Pareto analysis | Prioritize worst routes, don't spray-fix all locations | Problem is concentrated, not random |
| Late rate flat year-round | 48 months of data | Don't invest in seasonal capacity or blame weather | Problem is baked into operations |
| Profit difference: <$1 per order | t-test, p = 0.11 | Don't justify investment by margin improvement | Real cost is customer churn (invisible in data) |
| ML model can't predict delays | ROC-AUC 0.525 | Don't buy predictive analytics yet | Need real-time data (weather, tracking, port status) |

---

## 6. Decision Tree

```
Why are 57% of deliveries late?
│
├── Is it seasonal? (rainy season, Q4 peak)
│   └── NO — flat 55% every month for 4 years
│       → Remove seasonal capacity planning as the fix
│
├── Is it warehouse processing?
│   ├── Evidence: Standard (60% late) vs Second (47% late)
│   │   └── Same warehouse, different modes
│   ├── If warehouse were the bottleneck: ALL modes equally late
│   └── Since they're NOT equal: warehouse is NOT the bottleneck
│       → Remove warehouse racking/inventory upgrade as the fix
│
├── Is it carrier/transport?
│   ├── Evidence: Standard Class disproportionately worse
│   ├── Evidence: 20% origins → 71% late orders (concentrated)
│   └── YES → This is a vendor management failure
│       → Shift to asset-light strategy (SLAs, RFPs, chargebacks)
│
└── Recommendation: Enforce SLAs and diversify carrier network
    └── If chargebacks fail → Issue RFP for new 3PLs
    └── Do not spend CapEx on fleet or warehouse until vendor levers are exhausted
```

---

## 7. Data Limitations

| Missing Data | Why It Matters | What We'd Learn If We Had It |
|-------------|----------------|------------------------------|
| Carrier/transporter IDs | Cambodia's trucking market is fragmented (many small operators) | Which specific transport companies to drop or renegotiate with |
| Warehouse processing timestamps | Can't measure inbound→outbound time | Whether the bottleneck is at supplier (goods leave late) or our warehouse (slow dispatch) |
| Freight costs per delivery | Can't calculate TCO of fleet vs using carriers | Total cost avoidance by enforcing SLAs over CapEx |
| Rainy season / weather data | Wet season (May-Oct) is a major logistics factor in Cambodia | Quantifies weather's actual impact on delays |
| Customer retention data | Can't track which retailers churn or why | Dollar cost of late delivery in lost lifetime value |

---

## 8. Project Stats

| Metric | Value |
|--------|-------|
| **Total files tracked** | 28 |
| **Notebooks** | 2 |
| **SQL scripts** | 4 |
| **Python modules** | 2 (`src/__init__.py`, `src/utils.py`) |
| **Reports** | 3 |
| **Visuals** | 12 PNG files |
| **Git commits** | 9 (showing progressive development) |
| **Data rows** | 180,519 orders |
| **Data timeframe** | 2015–2018 |
| **Python packages required** | 8 |
| **Statistical tests** | 1 (Welch t-test) |

---

## 9. How to Run Everything

```bash
# 1. Database setup
psql -d supply_chain -f sql/00_create_table.sql

# 2. Import data (from psql)
\copy datacosupplychaindataset FROM 'data/DataCoSupplyChainDataset.csv' WITH CSV HEADER DELIMITER ',' ENCODING 'LATIN1'

# 3. Run analysis queries
psql -d supply_chain -f sql/01_supply_chain_kpis.sql
psql -d supply_chain -f sql/02_shipping_and_routes.sql
psql -d supply_chain -f sql/04_data_quality_check.sql

# 4. Python setup
pip install -r requirements.txt
cp .env.example .env   # Fill in DB credentials

# 5. Run notebooks (from project root)
jupyter notebook notebooks/01_cleaning_and_exploration.ipynb
jupyter notebook notebooks/02_root_cause_analysis.ipynb

# Or execute headlessly:
jupyter nbconvert --to notebook --execute notebooks/01_cleaning_and_exploration.ipynb --output /tmp/nb01.ipynb
jupyter nbconvert --to notebook --execute notebooks/02_root_cause_analysis.ipynb --output /tmp/nb02.ipynb
```
