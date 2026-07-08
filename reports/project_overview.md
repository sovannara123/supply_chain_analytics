# Project Overview — Mekong Distribution

## The Company

Mekong Distribution Co., Ltd. is a Phnom Penh-based importer and distributor of consumer goods. We source products from Vietnam, Thailand, and China, and deliver to approximately 800 retail partners across Cambodia.

- **Revenue:** ~$8M/year
- **Employees:** ~120
- **Warehouse:** 1 main facility in Phnom Penh
- **Delivery fleet:** Mix of company-owned trucks and hired third-party carriers
- **Key routes:** Phnom Penh → Siem Reap, Phnom Penh → Battambang, Phnom Penh → Sihanoukville, plus provincial towns

---

## The Business Problem

Our retailers are complaining. Late deliveries are the #1 issue cited. Some have already started sourcing from competitors who offer more reliable delivery.

The Operations Director has two investment requests on his desk, totaling more than we can spend:

| Request | Amount | Who's asking |
|---------|--------|-------------|
| 2 additional delivery trucks | $80,000 | Logistics team |
| Warehouse racking & inventory system upgrade | $60,000 | Warehouse team |

**He has 3 weeks to decide. We don't have budget for both.**

The question: **Which investment will actually reduce late deliveries?**

---

## The Data

We analyzed 180,000 orders from our sales database covering 2015–2018.

**What we had:**
- Order details (dates, products, quantities, prices)
- Delivery details (shipping mode, scheduled vs actual dates, delivery status)
- Customer and supplier locations
- Profit and sales per order

**What we didn't have (critical gaps):**
- Carrier/transporter IDs (we use multiple trucking companies)
- Warehouse processing timestamps (in vs out times)
- Freight costs per delivery
- Weather / rainy season data
- Customer retention data

---

## Analysis Pipeline

```
Raw Orders (180K)
    │
    ▼
Clean & Validate ─── Data quality checks, handle missing values,
    │                 remove artifacts (First Class data was fake)
    ▼
Exploratory Analysis ── 57% late rate discovery, patterns by
    │                     shipping mode, region, product
    ▼
Root Cause Analysis ─── Pareto analysis (20% origins → 71% late),
    │                     Standard vs Second Class comparison,
    │                     seasonality check, what-if simulation
    ▼
Recommendation ──────── Buy trucks, don't upgrade warehouse
```

---

## Key Findings

### 1. Over half our deliveries are late — and it's not seasonal

57.3% of orders arrive later than scheduled. This rate is **flat year-round** — same in wet season as dry season. No Q4 spikes, no rainy season surges. The problem is baked into how we operate, not caused by weather or seasonal volume.

### 2. Standard Class is the problem

| Shipping Mode | % of Orders | Late Rate | Avg Delay (days) |
|--------------|-------------|-----------|-----------------|
| Standard Class | 59.7% | 60.2% | 4.1 |
| Second Class | 27.8% | 46.7% | 2.8 |
| First Class* | 15.4% | 100%* | 1.0 |

*First Class data is an artifact — all 27K orders have identical shipping times. Not real data.*

Standard Class represents 60% of our volume and has a 60% late rate. Second Class goes through the **same warehouse** but is only 47% late. The warehouse doesn't know which delivery class an order uses. The difference is on the road.

### 3. The problem is concentrated, not spread

**20% of origin cities cause 71% of late orders.** This isn't a random pattern. Specific supplier locations are driving the majority of delays. This points to route-specific and carrier-specific issues, not a warehouse capacity problem.

### 4. Late deliveries don't directly cost us margin — but they cost us customers

| Delivery Status | Avg Profit per Order |
|----------------|---------------------|
| On-Time | $33.08 |
| Late | $32.67 |

The $0.41 difference is negligible. The real cost is invisible in this data — retailers who leave because of unreliable delivery. We're already seeing $1.57M in canceled/fraud orders, and some of those cancellations are likely driven by chronic late delivery.

### 5. We can't predict which orders will be late

We attempted to build a predictive model using order-level features (product, customer, location, shipping mode). **Result: ROC-AUC 0.525** — barely better than random guessing. Static order data doesn't contain the signals needed to predict delays. Real-time data (truck GPS, road conditions, border crossing status) would be needed.

---

## Recommendation: Buy the trucks, don't upgrade the warehouse

**The bottleneck is on the road, not inside the building.**

| Evidence | What it tells us |
|----------|-----------------|
| Standard Class (60% late) vs Second Class (47% late) | Same warehouse, different late rate = not a warehouse problem |
| 20% of origins → 71% of late orders | Route-specific, not facility-wide |
| Flat year-round, no wet season spike | Not a capacity or weather problem |

### The plan

1. **This week:** Ask the ops team for carrier/transporter records. If one trucking company causes most standard-class delays, talk to them before buying our own trucks.
2. **Next month:** Buy 1 truck ($40K) for the Phnom Penh–Siem Reap route — our highest-volume corridor. Run a pilot for 3 months. Measure the late rate before and after.
3. **If the pilot works:** Buy the second truck for Phnom Penh–Battambang.
4. **Don't upgrade the warehouse** unless and until in-house delivery improves but delays persist. That would mean the bottleneck is picking/packing, not transit.

### Estimated impact

| Scenario | Late deliveries eliminated | Profit protected |
|----------|---------------------------|-----------------|
| Fix worst 20% of origins to company average | ~50,000 | ~$1.7M |
| Fix Standard Class to Second Class levels | ~14,000 | ~$462K |
| 1 truck pilot on PNH–REP route | TBD — needs A/B test | TBD |

---

## Open Questions

1. **Which trucking companies are worst?** We need carrier IDs from ops records. Without them, we're solving at the route level when the problem may be at the carrier level.
2. **Is the bottleneck at the supplier or our warehouse?** Goods could be leaving suppliers late, or sitting in our warehouse before dispatch. Different fixes.
3. **How much does late delivery cost in lost retailers?** We don't track which retailers churn or why.
4. **Would shifting standard to second-class delivery help?** Only an A/B test can tell us. Historical data can't prove causality.

---

## Files

```
supply-chain-analytics/
├── README.md                          ← You are here
├── reports/
│   ├── project_overview.md            ← This document
│   └── github_audit_prompt.md         ← Pre-publish audit checklist
├── notebooks/
│   ├── 01_cleaning_and_exploration    ← Data cleaning + initial discovery
│   └── 02_root_cause_analysis         ← Root causes + recommendation
├── sql/                               ← DDL, views, analysis queries
├── visuals/                           ← Charts and figures
└── data/                              ← CSV (download from Kaggle)
```
