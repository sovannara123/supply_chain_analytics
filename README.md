# 🚚 Supply Chain Optimization & Logistics Analytics

**Global Supply Chain Performance & Resilience Analysis**

![Python](https://img.shields.io/badge/Python-3.11-blue)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-F2C811)
![License](https://img.shields.io/badge/License-MIT-green)

## 📌 Business Scenario
A global manufacturing and distribution company is facing rising freight costs, unpredictable lead times, and inventory imbalances. This project analyzes their end-to-end supply chain data to identify bottlenecks, score supplier reliability, and provide data-driven recommendations to build a more resilient, cost-effective logistics network.

## 🎯 Objectives
- Calculate OTIF (On-Time In-Full) and other core logistics KPIs
- Identify the most delay-prone shipping routes and modes
- Score and rank supplier reliability
- Optimize inventory levels using ABC/XYZ analysis
- Predict the risk of late delivery using machine learning
- Provide an interactive "Control Tower" dashboard for stakeholders

## 🗂️ Project Structure
```
supply-chain-analytics/
├── data/
├── notebooks/
├── sql/
├── dashboard/
├── visuals/
├── reports/
├── README.md
├── requirements.txt
└── LICENSE
```

## 📊 Dataset
**DataCo Smart Supply Chain Dataset** (Kaggle) — 180,000+ real-world orders including shipping, inventory, and supplier data.

## 🔧 Tech Stack
- **Python:** Pandas, NumPy, Scikit-learn, Plotly, Folium
- **SQL:** PostgreSQL (CTEs, Window Functions, Supplier Scoring)
- **BI:** Power BI (DAX, Geographic Maps, Control Tower Dashboard)

## 📈 Key Deliverables
- 6 Python notebooks (Cleaning → Predictive Modeling)
- 5 production-ready SQL scripts
- 1 interactive Power BI Control Tower dashboard
- Executive summary & presentation

## 🧠 Hypotheses Tested
| # | Hypothesis | Result |
|---|-----------|--------|
| H1 | Expedited shipping has lower late delivery risk than Standard | **Rejected** — Standard Class 60.2% on-time vs First Class 0.0% (data quality caveat: all First Class orders have zero-variance 2-day actual shipping, suggesting artifact) |
| H2 | Ocean freight has highest lead time variance | **Partially confirmed** — Central Africa 60.7% late (worst), Canada 51.9% best; no explicit ocean/air mode column |
| H3 | 20% of suppliers cause 80% of delays (Pareto) | **Confirmed** — Top 20% origins → 71.0% of late orders |
| H4 | Late deliveries correlate with lower margins | **Not confirmed** — On-Time avg profit $33.08 vs Late $32.67 (negligible) |
| H5 | Order volume peaks seasonally in Q4 | **Not confirmed** — Q1 ($9.47M) highest, Q4 ($8.47M) lowest |

## 👤 Author
Built as part of a Data Analytics portfolio — demonstrating end-to-end skills across cleaning, SQL, statistics, ML, and BI dashboard design.

## ⚠️ Limitations & Known Issues

1. **No explicit supplier ID** — Supplier scoring uses `order_city | order_country` as a proxy (3,665 unique origins), not actual supplier identifiers. Results are directional, not actionable at the vendor level.

2. **No freight cost column** — The dataset lacks shipping cost/freight rate data. Questions A2 (logistics cost), C4 (volume vs freight cost), D3 (supplier freight variance), and E1 (cost per transport mode) could not be fully answered.

3. **First Class shipping data anomaly** — All 27,814 First Class orders show zero variance: `days_for_shipment_scheduled = 1` and `days_for_shipping_real = 2` uniformly. This likely reflects a data generation artifact rather than real operational data.

4. **ML model ROC-AUC 0.537 (near random)** — After removing leaky features (`order_status`, post-hoc delay columns) and switching to a time-based train/test split, the XGBoost model performs barely above random. This is an honest result: static order features alone are insufficient to predict future delivery delays. Real-time logistics data (weather, port congestion, carrier tracking) would be needed for production-grade performance.

5. **No inventory level data** — The dataset records orders but not stock-on-hand. Inventory turnover (A5) could not be calculated directly; a proxy estimate is provided using sales velocity.

6. **Dataset is historical (2015–2018)** — All analysis is retrospective. Real supply chain analytics requires scheduled pipeline refreshes (daily/weekly) with streaming data.

7. **SQL scripts are SQLite-compatible** — Written and tested against SQLite. `STDDEV` and `LEAST` functions were adapted; for PostgreSQL/MySQL, revert to native syntax.

8. **Dashboard** — An interactive HTML dashboard is available at `dashboard/supply_chain_dashboard.html` (Plotly-based). A native Power BI `.pbix` file can be generated on Windows if needed.

⭐ If you find this useful, please star the repo!
