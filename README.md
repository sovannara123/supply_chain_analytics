# Late Delivery Root Cause Analysis

**Company:** Mekong Distribution Co., Ltd. — Phnom Penh  
**Stakeholder:** Operations Director  
**Deadline:** 3 weeks  
**Revenue:** ~$8M/year | **Employees:** ~120

**The problem:** We import consumer goods from Vietnam, Thailand, and China and deliver to ~800 retail partners across Cambodia. Our retailers are complaining. Some have started buying from competitors. The #1 complaint is late deliveries.

Operations wants to buy 2 more delivery trucks ($80K). Warehouse wants to upgrade our racking and inventory system ($60K). We don't have budget for both. The Operations Director needs data to decide which investment cuts the late rate.

I pulled 180K orders from our sales database to find out **why so many shipments arrive late, and whether we should invest in trucks or warehouse upgrades to fix it.**

Executive summary for the Operations Director at [`reports/executive_summary.md`](reports/executive_summary.md).
Full project overview at [`reports/project_overview.md`](reports/project_overview.md).

## Key findings

- **57.3% of orders arrive late** — it's a systemic problem, not seasonal
- **Standard Class shipping** accounts for 60% of all orders and has a 60.2% late rate. Fixing this one mode addresses the majority of delays.
- **Pareto: 20% of origin locations cause 71% of late orders.** The problem is concentrated, not random.
- **The ML model could not predict late deliveries** (ROC-AUC 0.525). Static order features aren't enough — you need real-time logistics data (weather, port congestion, carrier tracking).
- **Late vs on-time profit difference is negligible** ($33.08 vs $32.67). The cost is in customer retention, not margin.
- **Recommendation for the Operations Director: buy the trucks, don't upgrade the warehouse.** Standard Class is disproportionately bad (60% late vs 47% for Second Class). The problem is on the road, not in the warehouse. Adding trucks targets the real bottleneck. Upgrading racking wouldn't change the late rate.

## Notebooks

Run in order:
1. `notebooks/01_cleaning_and_exploration.ipynb` — load, clean, discover the 57% problem
2. `notebooks/02_root_cause_analysis.ipynb` — root causes, what-if analysis, and whether to buy trucks or upgrade the warehouse

## Setup

### Database

This project loads data from a PostgreSQL database. First, create the database and table:

```bash
psql -d supply_chain -f sql/00_create_table.sql
```

Then import the CSV data:

```bash
\copy datacosupplychaindataset FROM 'data/DataCoSupplyChainDataset.csv' WITH CSV HEADER DELIMITER ',' ENCODING 'LATIN1'
```

This creates both the raw table and the `analysis_ready` view used by the notebooks.

### Python

```
pip install -r requirements.txt
```

Data is from the DataCo Smart Supply Chain dataset on Kaggle. The original CSV is too large for GitHub; download from Kaggle and place in `data/`.

## Known issues

- **No carrier/transporter IDs** — Cambodia's trucking market is fragmented (many small operators). Without carrier IDs, I can't tell which transport companies to drop or renegotiate with.
- **First Class / Same Day delivery data is an artifact** — all 27K orders have identical shipping times (scheduled=1d, real=2d). Zero variance. A data generation issue in the Kaggle dataset. Not real delivery data.
- **Supplier analysis uses city|country as a proxy** — not real supplier IDs. A city like "Phnom Penh" has dozens of actual suppliers. The Pareto finding (71/20) is directional, not actionable at vendor level.
- **No freight costs** — without cost per delivery, I can't calculate ROI of buying trucks vs using third-party carriers
- **No rainy season data** — Cambodia's wet season (May-Oct) is a major logistics factor. The dataset doesn't include weather data, so I couldn't quantify its impact on delays.
- **No customer retention data** — I can calculate lost revenue from canceled orders ($1.57M) but not the lifetime value impact of retailers switching to competitors
- **Data is from 2015-2018** — retrospective. Current operations may have changed.

## How my thinking changed

I started this analysis assuming the late deliveries were a rainy season problem — flooded roads during wet season (May-Oct) slowing down our trucks. Three things changed my mind:

1. **The 55% flat line (notebook 01).** Every month for 4 years, same rate. If it were weather-related, I'd see clear wet season spikes. I don't. The problem is operational, not seasonal.
2. **Standard vs Second Class (notebook 02).** Same suppliers, same warehouse, same destinations — but Standard is 60% late and Second is 47% late. The warehouse doesn't know which delivery class an order uses. The difference is on the road, not inside our building.
3. **The ML model failed (notebook 02).** I spent the most time on this and it produced the least value. The root cause analysis is where all the actionable findings are. If I'd stopped earlier, I'd have reached the same recommendation faster.

The arc: rainy season → operational → transport-specific. Each step narrowed the possible fixes until buying more trucks made more sense than upgrading the warehouse.

## What surprised me

- **The late rate was flat year-round.** I was sure the rainy season (May-Oct) would spike delays. Flooded roads, longer transit times. Nope — 55% every month for 4 years, wet season or dry. The problem isn't weather, it's how we operate.
- **The ML model couldn't predict anything.** I spent the most time on this and it produced the least value. The root cause analysis (notebook 02) is where all the actionable findings are.
- **Standard vs Second Class difference.** I expected all delivery modes to have similar late rates since they go through the same warehouse. Standard is 60% late, Second is 47%. That gap told me the bottleneck is on the road, not inside the building.
- **First Class data is an artifact.** All 27K First Class orders have identical shipping times. Zero variance. A data generation bug. I almost built conclusions on this before noticing.

## What I'd do differently

1. **Start with SQL, not Python.** Most of this analysis could have been done with 2-3 well-written SQL queries. I jumped to notebooks too fast.
2. **Request the right data upfront.** If I'd known there were no carrier IDs, warehouse locations, or freight costs, I would have framed the analysis differently — or asked for additional data before starting.
3. **Don't build models on bad proxies.** The supplier scoring model used city|country as a supplier identifier. That's not a real supplier. I should have flagged the limitation earlier and treated it as exploratory only.
4. **Kill the ML earlier.** I spent hours tuning XGBoost hyperparameters. The logistic regression baseline told me everything I needed to know in 5 seconds. Start with the simplest possible approach.
5. **Every chart needs a "so what."** Some of my early visualizations just described data. A hiring manager wants to know what action the chart drives, not what it shows.

## Questions I still can't answer

- Which specific trucking companies are causing the delays? (No carrier IDs in the data)
- Is the bottleneck at the supplier (goods leave late) or our warehouse (slow to dispatch)? (No warehouse processing timestamps)
- How much does late delivery cost us in lost retailers? (No post-purchase data — don't know which retailers churned)
- Would shifting standard to second-class delivery reduce the late rate? (Would need an A/B test — can't infer causality from historical data)

## Files

```
supply-chain-analytics/
├── data/               # Raw CSV (download from Kaggle)
├── notebooks/          # 01_cleaning, 02_root_cause
├── sql/                # DDL, view creation, analysis queries
├── src/                # Reusable Python modules (utils.py)
├── visuals/            # Saved charts and figures
├── reports/            # Executive summary, project overview, audit prompt
└── .env.example        # Database connection template (copy to .env)
```

Notebooks load data from the `analysis_ready` PostgreSQL view (see `sql/00_create_table.sql` for the schema).
