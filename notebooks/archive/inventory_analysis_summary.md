# Inventory Analysis Summary

**Notebook:** `notebooks/04_inventory_analysis.ipynb`

## ABC Classification (Revenue Contribution)

| Class | Products | Total Sales | % Revenue | Strategy |
|-------|----------|-------------|-----------|----------|
| **A** | 6 | $25,384,501 | ~70% | Tight inventory control, frequent review |
| **B** | 4 | $7,712,834 | ~20% | Moderate monitoring |
| **C** | 108 | $3,687,400 | ~10% | Simplified replenishment, bulk ordering |

**Top A-items:** Fishing ($6.9M), Cleats ($4.4M), Camping & Hiking ($4.1M), Cardio Equipment ($3.7M), Women's Apparel ($3.1M), Water Sports ($3.1M)

## XYZ Classification (Demand Volatility)

| Class | Products | CV Range | Strategy |
|-------|----------|----------|----------|
| **X** | 115 | ≤ 0.5 | Forecast-driven, stable demand |
| **Y** | 3 | 0.5–1.0 | Moderate safety stock |
| **Z** | 0 | > 1.0 | High safety stock, demand shaping |

## ABC-XYZ Matrix

| | X (Stable) | Y (Moderate) | Z (Volatile) |
|---|---|---|---|
| **A** (Top revenue) | 6 | 0 | 0 |
| **B** (Mid revenue) | 4 | 0 | 0 |
| **C** (Low revenue) | 105 | 3 | 0 |

**Insight:** Nearly all products have stable demand (CV ≤ 0.5). Only 3 C-class items show moderate volatility.

## Order Status Analysis

| Status | Orders | Sales | % Total |
|--------|--------|-------|---------|
| COMPLETE | 59,491 | $12,095,315 | 32.9% |
| PENDING_PAYMENT | 39,832 | $8,106,698 | 22.1% |
| PROCESSING | 21,902 | $4,504,064 | 12.1% |
| PENDING | 20,227 | $4,120,533 | 11.2% |
| CLOSED | 19,616 | $4,022,624 | 10.9% |
| ON_HOLD | 9,804 | $1,981,543 | 5.4% |
| SUSPECTED_FRAUD | 4,062 | $825,935 | 2.3% |
| CANCELED | 3,692 | $744,370 | 2.0% |
| PAYMENT_REVIEW | 1,893 | $383,654 | 1.0% |

**Lost orders (Canceled + Suspected Fraud):** 7,754 orders (4.3%) — $1,570,305 in lost sales

## Department Profitability

| Department | Sales | Profit | Orders | Margin |
|------------|-------|--------|--------|--------|
| Fan Shop | $17,113,871 | $2,885,062 | 66,861 | 12% |
| Apparel | $7,976,255 | $1,258,741 | 48,998 | 12% |
| Golf | $4,609,028 | $703,943 | 33,220 | 12% |
| Footwear | $4,006,499 | $654,326 | 14,525 | 12% |
| Outdoors | $1,253,351 | $193,673 | 9,686 | 13% |
| Technology | $1,039,599 | $111,361 | 1,465 | 13% |

## Seasonal Peaks

| Category | Peak Month | Orders |
|----------|-----------|--------|
| Cleats | March | 2,327 |
| Men's Footwear | August | 2,091 |
| Women's Apparel | August | 2,007 |
| Indoor/Outdoor Games | January | 1,827 |
| Fishing | June | 1,608 |
| Water Sports | May | 1,496 |

## Key Takeaways

1. **6 A-class products** drive 70% of revenue — prioritize their inventory accuracy
2. **Demand is very stable** — 115 of 118 products have CV ≤ 0.5, enabling reliable forecasting
3. **Fan Shop** is the highest-value department ($2.9M profit) across 66,861 orders
4. **4.3% of orders lost** to cancellation/fraud ($1.57M) — investigate root cause per category
5. **Cleats peak in March, Water Sports in May** — seasonality is predictable, plan safety stock accordingly
