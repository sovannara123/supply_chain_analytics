# supply chain late delivery analysis

I got 180K supply chain orders and asked one question: **why are 57% of our shipments late and what can we do about it?**

## Key findings

- **57.3% of orders arrive late** — it's a systemic problem, not seasonal
- **Standard Class shipping** accounts for 60% of all orders and has a 60.2% late rate. Fixing this one mode addresses the majority of delays.
- **Pareto: 20% of origin locations cause 71% of late orders.** The problem is concentrated, not random.
- **The ML model could not predict late deliveries** (ROC-AUC 0.525). Static order features aren't enough — you need real-time logistics data (weather, port congestion, carrier tracking).
- **Late vs on-time profit difference is negligible** ($33.08 vs $32.67). The cost is in customer retention, not margin.

## Notebooks

Run in order:
1. `notebooks/01_cleaning_and_exploration.ipynb` — load, clean, discover the 57% problem
2. `notebooks/02_root_cause_analysis.ipynb` — shipping modes, routes, suppliers, Pareto
3. `notebooks/03_predictive_model.ipynb` — honest attempt at prediction (and why it failed)

## Setup

```
pip install -r requirements.txt
```

Data is from the DataCo Smart Supply Chain dataset on Kaggle. The original CSV is too large for GitHub; download from Kaggle and place in `data/`.

## Known issues

- **No carrier IDs** in the data, so I couldn't do carrier-level analysis
- **First Class shipping data is an artifact** — all 27K orders have identical shipping times (scheduled=1d, real=2d). Not real data.
- **Supplier analysis uses city|country as a proxy** — not real supplier IDs. The Pareto finding (71/20) is directional, not actionable at the vendor level.
- **No freight costs** — can't quantify logistics cost impact
- **ML model doesn't work** — the honest finding is that static features can't predict delays. Real-time logistics data would be needed.
- **Data is from 2015-2018** — retrospective analysis only

## What I'd do differently

1. Start with the SQL root cause analysis before building any model. I jumped to ML too fast.
2. Request carrier IDs and freight costs before starting. Without those, the analysis has gaps.
3. Don't build a supplier scoring model on bad proxies (city|country). Better to leave it as a qualitative finding.

## Files

```
supply-chain-analytics/
├── data/               # Raw + cleaned CSVs (download original from Kaggle)
├── notebooks/          # 01_cleaning, 02_root_cause, 03_predictive
├── sql/                # SQL queries used in analysis
├── dashboard/          # Interactive HTML dashboard
├── visuals/            # Saved charts and figures
└── reports/            # Technical self-review
```
