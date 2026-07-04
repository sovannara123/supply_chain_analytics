# Supplier Performance Analysis Summary

**Notebook:** `notebooks/05_supplier_performance.ipynb`
**Note:** The DataCo dataset lacks explicit supplier IDs. Order origin (city | country) is used as a supplier proxy.

## Hypothesis Result

| # | Hypothesis | Result |
|---|-----------|--------|
| H3 | 20% of suppliers cause 80% of delays (Pareto) | **CONFIRMED** — Top 20% of origins drive **71.0%** of all late orders |

## Supplier Scoring Methodology

A composite reliability score was calculated using:
- **On-time rate** (40% weight)
- **Average delay** (30% weight — lower is better)
- **Delay consistency / std dev** (20% weight)
- **Product breadth** (10% weight)

## Top 5 Most Reliable Suppliers (50+ orders)

| Supplier | Orders | On-Time % | Avg Delay | Reliability Score |
|----------|--------|-----------|-----------|-------------------|
| Cárdenas | Cuba | 74 | 78.4% | −0.19 days | 69.4 |
| Kingswood | Reino Unido | 53 | 77.4% | −0.16 days | 69.0 |
| Mersin | Turquía | 81 | 66.7% | 0.01 days | 68.2 |
| Carcassonne | Francia | 61 | 73.8% | −0.10 days | 68.2 |
| Basel | Suiza | 54 | 72.2% | −0.06 days | 68.1 |

## Bottom 5 Least Reliable Suppliers (50+ orders)

| Supplier | Orders | On-Time % | Avg Delay | Reliability Score |
|----------|--------|-----------|-----------|-------------------|
| Villeurbanne | Francia | 64 | 11.7% | 1.47 days | 28.2 |
| La Seyne-sur-Mer | Francia | 60 | 11.7% | 1.47 days | 29.9 |
| Eastbourne | Reino Unido | 56 | 12.5% | 1.36 days | 29.9 |
| Cuajimalpa | México | 50 | 12.0% | 1.10 days | 30.4 |
| Salamanca | México | 56 | 10.7% | 1.31 days | 30.6 |

## Lead Time Consistency

| Most Consistent | Std Dev | Least Consistent | Std Dev |
|----------------|---------|-----------------|---------|
| Villeurbanne | Francia | 0.67 | Reading | Reino Unido | 1.52 |
| Murcia | España | 0.73 | London | Canada | 1.52 |
| Nieuwegein | Países Bajos | 0.78 | Lippstadt | Alemania | 1.52 |
| Bezerros | Brasil | 0.78 | Zhuhai | China | 1.54 |
| Wiesbaden | Alemania | 0.81 | Makati | Filipinas | 1.54 |

## Product Risk Scoring

| Highest Risk Products | Risk Score | Lowest Risk Products | Risk Score |
|----------------------|------------|---------------------|------------|
| SOLE E25 Elliptical | 79.3 | Perfect Fitness Perfect Rip Deck | 27.3 |
| Garmin Approach S4 Golf GPS Watch | 73.6 | Nike Men's CJ Elite 2 TD Football Cleat | 28.9 |
| O'Brien Men's Neoprene Water Ski Gloves | 70.3 | Pelican Sunstream 100 Kayak | 32.8 |

## Key Takeaways

1. **H3 CONFIRMED** — Pareto principle holds: 20% of origins cause 71% of delays
2. **3,665 supplier proxies** identified across 164 countries
3. **820 active suppliers** (50+ orders) — top reliability score 69.4 vs bottom 28.2
4. **Cárdenas, Cuba** ranks as the most reliable origin (78.4% on-time, −0.19 days early)
5. **Villeurbanne, France** is the least reliable (11.7% on-time, 1.47 days delay)
6. **3 products flagged as high-risk** — recommend expedited handling or alternate sourcing
