# Logistics & Route Analysis Summary

**Notebook:** `notebooks/03_logistics_and_routing.ipynb`
**Dataset:** `data/supply_chain_cleaned.csv` (180,519 orders, 62 columns)

## Hypothesis Results

| # | Hypothesis | Result |
|---|-----------|--------|
| H1 | Expedited shipping has lower late delivery risk than Standard | **Rejected** — Standard Class (60.2% on-time) outperforms First Class (0.0%) and Same Day (52.2%) |
| H2 | Ocean/international routes have highest lead time variance | **Partial** — Central Africa (60.7% late) and South Asia (58.5%) are worst, but within-market variance is also high |

## Shipping Mode Performance

| Mode | Orders | On-Time % | Avg Delay (days) | Avg Profit |
|------|--------|-----------|------------------|------------|
| Standard Class | 107,752 | **60.2%** | 0.10 | $32.86 |
| Same Day | 9,737 | 52.2% | 0.48 | $31.60 |
| Second Class | 35,216 | 20.3% | 1.59 | $32.77 |
| First Class | 27,814 | **0.0%** | 1.00 | $33.32 |

> ⚠️ **Data Quality Note — First Class:** All 27,814 First Class orders have `days_for_shipment_scheduled = 1` and `days_for_shipping_real = 2` with zero variance. This uniformity suggests a data generation artifact rather than real operational data. The 0.0% on-time rate is correct per the data but should be interpreted with caution.

### Expedited vs. Standard

| Tier | Orders | On-Time % | Avg Delay | Avg Sales |
|------|--------|-----------|-----------|-----------|
| Expedited | 37,551 | 13.5% | 0.86 days | $202.84 |
| Standard | 142,968 | 50.4% | 0.47 days | $204.02 |

Expedited shipping costs more yet delivers **worse** on-time performance — a premium paid for slower, less reliable service.

## Regional Performance

| Region | Orders | Late Rate | Avg Delay |
|--------|--------|-----------|-----------|
| Central Africa | 1,677 | 60.7% | 0.62 days |
| Western Europe | 27,109 | 58.5% | 0.57 days |
| South Asia | 7,731 | 58.5% | 0.58 days |
| Central America | 28,341 | 57.3% | 0.55 days |
| Eastern Asia | 7,280 | 56.7% | 0.55 days |
| Canada | 1,429 | **51.9%** | 0.52 days |

## Route Analysis

- **39,107** unique origin→destination routes identified
- Worst routes (avg 2.5 days delay): Cormeilles-en-Parisis → New Brunswick, Basildon → Sugar Land, Manzanillo → La Habra
- Best routes (avg −0.1 days early): Glasgow → Caguas, Maracaibo → Caguas, Medellín → Caguas

## Cost Analysis

- Profit margins are consistent across all modes (~12-13%)
- No shipping mode delivers significantly higher profitability
- Recommendation: prioritize reliability over mode choice

## Visual Assets

| File | Description |
|------|-------------|
| `visuals/09_shipping_mode_performance.png` | On-time rate & delay by shipping mode |
| `visuals/10_route_delay_heatmap.png` | Market × Region delay heatmap |
| `visuals/11_delayed_routes.png` | Top 10 delay-prone routes |
| `visuals/12_regional_late_rate.png` | Late delivery rate by region |
| `visuals/13_cost_by_mode.png` | Profit & margin by shipping mode |
| `visuals/14_expedited_vs_standard.png` | Expedited vs Standard comparison |
| `visuals/delivery_map.html` | Interactive global delivery performance map |

## Key Takeaways

1. **Standard Class is the most reliable shipping mode** — 60.2% on-time at the lowest cost
2. **First Class performance anomaly** — 0% on-time rate warrants data investigation
3. **No profit advantage** from expedited shipping — margins are consistent across all modes
4. **Central Africa and Western Europe** are the most delay-prone regions
5. **Caguas, Puerto Rico** appears in most reliable routes — likely a distribution hub effect
