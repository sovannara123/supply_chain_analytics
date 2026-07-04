# Supply Chain Optimization & Logistics Analytics

**Alternative title:** Global Supply Chain Performance & Resilience Analysis

**Industry:** Supply Chain / Logistics / Manufacturing
**Project Type:** End-to-End Data Analytics (SQL + Python + Power BI)

---

## Business Scenario

A global manufacturing and distribution company has collected extensive data across its supply chain network, including procurement, inventory levels, shipping routes, order fulfillment, and supplier performance.
Management is facing rising freight costs, unpredictable lead times, and inventory imbalances (stockouts vs. overstock). They want to understand bottlenecks, evaluate supplier reliability, and optimize logistics to improve margins and customer satisfaction.
As a Data Analyst, your task is to analyze historical supply chain data to identify inefficiencies, calculate key operational metrics (like OTIF - On-Time In-Full), and provide actionable recommendations to build a more resilient and cost-effective supply chain.

## Project Objective

Analyze supply chain and logistics data to answer:

- Where are the biggest bottlenecks causing late deliveries?
- Which shipping modes and routes are the most/least cost-effective?
- Which suppliers are the most reliable versus high-risk?
- What are the optimal inventory levels to prevent stockouts without tying up capital?
- How do seasonal trends impact order volumes and freight costs?
- What factors most strongly predict the risk of a late delivery?
- What network optimizations can reduce total logistics costs?

## GitHub Project Structure

```
supply-chain-analytics/
│
├── data/
│   ├── supply_chain_data.csv
│   ├── supply_chain_cleaned.csv
│   └── data_dictionary.xlsx
│
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_exploratory_analysis.ipynb
│   ├── 03_logistics_and_routing.ipynb
│   ├── 04_inventory_analysis.ipynb
│   ├── 05_supplier_performance.ipynb
│   └── 06_predictive_late_delivery.ipynb
│
├── sql/
│   ├── 01_supply_chain_kpis.sql
│   ├── 02_shipping_and_routes.sql
│   ├── 03_inventory_levels.sql
│   ├── 04_supplier_scoring.sql
│   └── 05_cost_analysis.sql
│
├── dashboard/
│   ├── supply_chain_dashboard.html
│   └── screenshots/
│
├── visuals/
│
├── reports/
│   ├── Executive_Summary.pdf
│   ├── Presentation.pdf
│   ├── project_overview.md
│   ├── project_checklist.md
│   ├── data_cleaning_summary.md
│   ├── eda_summary.md
│   ├── logistics_routing_summary.md
│   ├── inventory_analysis_summary.md
│   ├── supplier_performance_summary.md
│   └── predictive_model_summary.md
│
├── README.md
├── requirements.txt
└── LICENSE
```

## Dataset

**DataCo Smart Supply Chain for Big Data Analysis (Kaggle)**
https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis

Typical columns:
- Order ID
- Order Date / Ship Date
- Days for shipping (Real) vs. Days for shipping (Scheduled)
- Delivery Status (Late, Advance, On-Time, Canceled)
- Late Delivery Risk (Binary)
- Shipping Mode (Standard, First Class, Same Day, Ocean, Air)
- Supplier ID / Supplier Region
- Origin City / Destination City
- Product Category / Product Name
- Order Quantity
- Inventory Status
- Freight Cost / Shipping Cost
- Unit Price / Total Order Margin

## Business Questions

### A. Executive KPIs
- What is the overall On-Time Delivery (OTD) rate?
- What is the total freight/logistics cost?
- What is the average order cycle time (lead time)?
- What is the total cost of lost/canceled orders?
- What is the average inventory turnover ratio?

### B. Logistics & Fulfillment Analysis
- Which shipping modes experience the highest delay rates?
- Which origin-destination routes are the most expensive?
- Which regions suffer from the highest volume of late deliveries?
- How does the actual shipping time compare to the scheduled shipping time by region?

### C. Inventory & Product Analysis
- Which product categories suffer the most from stockouts?
- Which products have the highest holding costs due to overstock?
- Are there seasonal spikes in demand for specific product categories?
- How does order volume impact freight costs?

### D. Supplier Performance Analysis
- Which suppliers have the highest defect or delay rates?
- Which suppliers offer the best lead-time consistency?
- How do freight costs vary among different suppliers for the same product categories?
- Which suppliers should the company prioritize or phase out?

### E. Cost & Profitability Analysis
- What is the shipping cost per unit across different transport modes?
- Are expedited shipping modes actually delivering on time, or are we paying a premium for delayed goods?
- How do late deliveries impact the overall order margin?

### F. Driver Analysis
- What factors most strongly predict the likelihood of a late delivery?
- Does shipping mode or geographic region have a bigger impact on lead time variance?
- Is there a correlation between order size (quantity) and shipping delays?

## Hypotheses

| # | Hypothesis |
|---|-----------|
| H1 | First Class/Expedited shipping has a significantly lower late delivery risk than Standard shipping. |
| H2 | International ocean routes have the highest variance in actual vs. scheduled lead times. |
| H3 | A small percentage of suppliers (e.g., 20%) are responsible for the majority (80%) of late deliveries. |
| H4 | Late deliveries correlate positively with lower overall profit margins per order. |
| H5 | Order volume exhibits strong seasonality, peaking in Q4 and straining logistics capacity. |

## Analysis Workflow

```
Business Understanding
        │
        ▼
Data Understanding
        │
        ▼
Data Cleaning
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Logistics & Route Analysis
        │
        ▼
Inventory Analysis
        │
        ▼
Supplier Scoring Analysis
        │
        ▼
Statistical & Predictive Analysis (Late Delivery Risk)
        │
        ▼
SQL Analysis
        │
        ▼
HTML Dashboard (Control Tower)
        │
        ▼
Operational Recommendations
```

## Technologies

**Python:** Pandas, NumPy, Matplotlib, Seaborn, Plotly, SciPy, Scikit-learn
**SQL:** PostgreSQL, MySQL, or SQLite — CTEs, Window Functions, Joins, CASE statements, Aggregations
**Power BI / Web:** Plotly HTML Dashboard, DAX, Supply Chain KPIs (OTIF, Lead Time), Map Visuals, Slicers, Interactive dashboards
**Tools:** Jupyter Notebook, Git, GitHub, VS Code

## Expected Deliverables

- 6 complete Python notebooks
- 5 SQL scripts
- 1 interactive Power BI dashboard ("Supply Chain Control Tower")
- Professional README
- Executive presentation
- Executive summary
- Clean dataset
- Visual assets for portfolio

## Skills Demonstrated

- Data Cleaning & Pipeline Building
- Exploratory Data Analysis
- Supply Chain KPI Development (OTIF, Cycle Time)
- SQL Analytics & Supplier Scoring
- Geographic Data Visualization (Mapping routes)
- Predictive Analytics (Risk of Delay)
- Logistics Cost Analysis
- Dashboard Design (Control Towers)
- Business Storytelling
- Operational Recommendations
