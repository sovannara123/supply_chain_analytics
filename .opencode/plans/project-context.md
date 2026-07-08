# Project Context — Mekong Distribution Late Delivery Analysis

## Company
- **Name:** Mekong Distribution Co., Ltd.
- **Location:** Phnom Penh, Cambodia
- **Business:** Imports consumer goods from Vietnam, Thailand, China; distributes to ~800 retail partners across Cambodia
- **Revenue:** ~$8M/year | **Employees:** ~120
- **Warehouse:** 1 main (Phnom Penh)
- **Fleet:** Mix of owned trucks and third-party carriers

## Business Problem
The Operations Director has 3 weeks to choose between:
- **Logistics request:** 2 more delivery trucks ($80K)
- **Warehouse request:** Racking and inventory system upgrade ($60K)
- Budget only covers one.

Late deliveries are the #1 complaint from retailers. Some have started buying from competitors.

## Key Findings (from analysis)
- 57.3% of orders arrive late — systemic, not seasonal
- Standard Class: 60% of orders, 60.2% late rate
- Second Class: 47% late rate (same warehouse, same products)
- Pareto: 20% of origin cities → 71% of late orders
- No rainy season pattern — flat 55% year-round
- ML model failed (ROC-AUC 0.525) — can't predict delays with static data
- Profit difference between late/on-time is negligible ($33 vs $32)

## Recommendation
**Buy the trucks, don't upgrade the warehouse.**
- The problem is on the road (carrier/transit), not inside the building (warehouse processing)
- Standard vs Second Class gap proves the warehouse isn't the bottleneck
- Pilot: buy 1 truck for Phnom Penh-Siem Reap route, measure for 3 months

## Files Created This Session
1. `reports/project_overview.md` — stakeholder-facing project overview (written for Operations Director)
2. `reports/github_audit_prompt.md` — reusable prompt template for pre-publish audit (6-gate system)
3. `.opencode/plans/project-context.md` — session persistence file

## What's Been Fixed This Session
1. **README.md** — reframed from "global retailer" to Cambodian distribution company context ($200M → $8M, VP of Ops → Operations Director, carrier automation → trucks vs warehouse)
2. **notebooks/01_cleaning_and_exploration.ipynb** — opening story rewritten with Cambodian company context
3. **notebooks/02_root_cause_analysis.ipynb** — opening, recommendation section, and ops questions section rewritten for Cambodia context

## Remaining Work (Priority Order)

### Must Fix Before Publishing (COMPLETED)
- [x] Add statistical test (t-test on late vs on-time profit difference) in notebook 02 — 5 min
- [x] Delete `reports/technical_review.md` — AI-generated document flagged by audit
- [x] Remove ML code cells from notebook 02, keep only conclusion text — already clean per audit
- [x] Removed all stale "VP" (8 references) and "carrier renegotiation" (5 references) from both notebooks — replaced with "Operations Director" / neutral phrasing

### High Impact
- [ ] Split git history into multiple commits showing iteration — 20 min
- [ ] Create `src/utils.py` with shared functions (`save_fig`, `load_data`) — 1 hr
- [ ] Add chi-square test for mode-delay independence — 30 min
- [ ] Create `reports/executive_summary.md` (1-page for Operations Director) — 1 hr

### Medium Priority
- [ ] Fix deprecated `select_dtypes(include='str')` → `select_dtypes(include='object')` in both notebooks — 5 min
- [ ] Move hardcoded DB credentials to `.env` — 15 min
- [ ] Add rough dollar estimate for Pareto fix — 20 min
- [ ] Add A/B test recommendation section — 15 min

### Optional
- [ ] Time-series decomposition of delays — 1 hr
- [ ] Perfect Order Rate calculation — 20 min

## Data Source
DataCo Smart Supply Chain dataset (Kaggle). 180K orders, 62 features, 2015-2018. Global data used to simulate analysis for a Cambodian distribution company context.

## Known Limitations
- No carrier/transporter IDs — Cambodia's trucking market is fragmented
- First Class shipping data is an artifact (zero variance in shipping times)
- Supplier analysis uses city|country proxy — not real supplier IDs
- No freight costs — can't calculate truck-vs-carrier ROI
- No rainy season data in the original dataset
- No customer retention data — can't quantify churn cost of late delivery
