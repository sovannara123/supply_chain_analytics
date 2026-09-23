# Executive Summary — Mekong Distribution

**To:** Operations Director
**From:** Data Analysis
**Date:** July 2026
**Subject:** Late delivery root cause — vendor performance vs. internal capacity

---

## The problem

57% of our deliveries arrive late. Retailers are complaining. Some have started buying from competitors.

You have two investment requests on your desk totaling more than budget allows. This analysis determines which one addresses the root cause.

## The finding

**The bottleneck is on the road, not in the warehouse.**

**1. The warehouse isn't the problem.**
All delivery modes originate from the same warehouse, but Standard and First Class are driving the delays. The difference happens on the road.

![Shipping Modes Late Rate](../visuals/shipping_modes.png)

**2. The problem is concentrated in specific routes.**
A Pareto analysis shows that delays are heavily concentrated. Addressing the routes leaving these 10 origin cities will have a massive cascading effect.

![Top 10 Worst Origin Cities](../visuals/worst_cities.png)

**3. The problem is structural, not seasonal.**
This is not a rainy season anomaly. The late rate has been stuck at ~55% every month for 4 years.

![Seasonal Trend](../visuals/seasonal_trend.png)

*(Note: While the direct profit difference between a late vs. on-time order is only $0.41, the true cost lies in customer churn which this data cannot quantify).*

## The strategic recommendation

**Enforce Carrier SLAs and Diversify Routes. Do not buy a fleet.**

### Why

The data reveals a heavy supplier concentration risk (20% of cities cause 71% of late orders), and failure is isolated almost entirely to Standard Class deliveries. This indicates a vendor performance failure on the road, not an internal warehouse capacity issue. 

Purchasing an in-house fleet is a massive CapEx (capital expenditure) commitment with heavy hidden total cost of ownership (TCO) in fuel, drivers, and maintenance. By shifting to an asset-light strategy, we can eliminate delays through better vendor management without spending capital.

### What to do

1. **This week:** Audit our existing 3PL (Third Party Logistics) contracts for the 10 worst origin cities. Implement strict Service Level Agreements (SLAs) with financial chargebacks for late deliveries.
2. **Next month:** Issue an RFP (Request for Proposal) to onboard a secondary carrier for the worst-performing Standard Class routes. Breaking the single-source dependency immediately creates competition and better service.
3. **Continuous:** Adjust the system's promised delivery dates. If standard routes structurally take 4 days instead of 3, promise the customer 4 days. This eliminates customer churn expectations at zero cost.

### Estimated impact

![ROI Projection](../visuals/roi_projection.png)

## Data limitations

This analysis uses 180K orders from 2015–2018. The dataset lacks:

- **Carrier IDs** — can't name which trucking companies to drop or renegotiate with
- **Warehouse timestamps** — can't measure how long goods sit before dispatch
- **Freight costs** — can't calculate the exact Total Cost of Ownership (TCO) difference between an in-house fleet and 3PL SLAs
- **Customer churn data** — can't quantify how many retailers we've lost to late delivery

**Bottom line:** The data indicates a severe vendor performance issue on the road. Do not spend CapEx on trucks or warehouse upgrades until 3PL SLAs are enforced.

---

*Full technical analysis: `notebooks/02_root_cause_analysis.ipynb`*
