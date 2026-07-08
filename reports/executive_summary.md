# Executive Summary — Mekong Distribution

**To:** Operations Director
**From:** Data Analysis
**Date:** July 2026
**Subject:** Late delivery root cause — trucks or warehouse upgrade?

---

## The problem

57% of our deliveries arrive late. Retailers are complaining. Some have started buying from competitors.

You have two investment requests on your desk totaling more than budget allows. This analysis determines which one addresses the root cause.

## The finding

**The bottleneck is on the road, not in the warehouse.**

| Evidence | What it tells us |
|----------|-----------------|
| Standard Class is 60% late; Second Class is 47% late — same warehouse, same products | The warehouse isn't the problem. It doesn't know which delivery class an order uses. |
| 20% of origin cities cause 71% of late orders | The problem is concentrated in specific routes and carriers, not across all operations. |
| Late rate is flat year-round — 55% every month for 4 years | Not a rainy season or capacity issue. The problem is structural, not seasonal. |
| Late vs on-time profit differs by only $0.41 per order | The direct cost isn't in margin — it's in customer churn, which this data can't measure. |

## The recommendation

**Buy the trucks. Don't upgrade the warehouse yet.**

### Why

If the warehouse were the bottleneck, all delivery modes would be equally delayed. They're not. Standard Class — our most common mode — is disproportionately late. The difference is on the road.

Warehouse racking and a better inventory system would improve picking efficiency but wouldn't change delivery speed. The late rate would stay roughly the same.

### What to do

1. **This week:** Ask ops for carrier records. If one trucking company causes most standard-class delays, talk to them before buying our own trucks.
2. **Next month:** Buy 1 truck ($40K). Run it on Phnom Penh–Siem Reap — our busiest route. Measure late rates before and after for 3 months.
3. **If it works:** Buy the second truck for Phnom Penh–Battambang.
4. **If delays persist after in-house trucks:** Then investigate the warehouse. The bottleneck may be picking/packing after all.

### Estimated impact

| Scenario | Late orders eliminated | Profit protected |
|----------|----------------------|-----------------|
| Fix worst 20% of origins to company average | ~50,000 | ~$1.7M |
| Fix Standard Class to Second Class levels | ~14,000 | ~$462K |
| 1 truck pilot on Phnom Penh–Siem Reap | TBD — needs before/after measurement | TBD |

## Data limitations

This analysis uses 180K orders from 2015–2018. The dataset lacks:

- **Carrier IDs** — can't name which trucking companies to drop or renegotiate with
- **Warehouse timestamps** — can't measure how long goods sit before dispatch
- **Freight costs** — can't calculate truck purchase ROI vs carrier fees
- **Customer churn data** — can't quantify how many retailers we've lost to late delivery

**Bottom line:** The data supports buying trucks. But get carrier records first — you may not need to buy anything if one carrier is the problem.

---

*Full technical analysis: `notebooks/02_root_cause_analysis.ipynb`*
