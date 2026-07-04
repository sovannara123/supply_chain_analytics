# Data Cleaning Summary

**Dataset:** DataCo Smart Supply Chain (180,519 orders × 53 raw columns)
**Notebook:** `notebooks/01_data_cleaning.ipynb`

## Pipeline Overview

| Step | Action | Rows | Cols |
|------|--------|------|------|
| 1 | Load CSV (latin-1 encoding) | 180,519 | 53 |
| 2 | Standardize column names to snake_case | 180,519 | 53 |
| 3 | Drop `order_zipcode` (86% missing) & `product_description` (100% missing) | 180,519 | 51 |
| 4 | Fill categorical NaNs with `'Unknown'`, numeric NaNs with median | 180,519 | 51 |
| 5 | Remove duplicate rows | 180,519 | 51 |
| 6 | Parse `order_date_dateorders` & `shipping_date_dateorders` to datetime | 180,519 | 51 |
| 7 | Feature engineering (see below) | 180,519 | 64 |
| 8 | Cap outliers via IQR (1.5× rule) on 7 numeric columns | 180,519 | 64 |
| 9 | Drop single-value columns (`customer_email`, `customer_password`) | 180,519 | **62** |

## Missing Values Handled

| Column | Missing | Action |
|--------|---------|--------|
| `order_zipcode` | 155,679 (86%) | Dropped (>50% threshold) |
| `product_description` | 180,519 (100%) | Dropped (>50% threshold) |
| `customer_lname` | 8 | Filled with `'Unknown'` |
| `customer_zipcode` | 3 | Filled with median |

## Features Engineered

| Feature | Description |
|---------|-------------|
| `order_year/month/day/quarter/hour` | Datetime components from order date |
| `order_dayofweek` | 0 = Monday, 6 = Sunday |
| `is_weekend` | 1 if Sat/Sun |
| `order_season` | Winter / Spring / Summer / Fall |
| `shipping_year/month` | Datetime components from shipping date |
| `actual_shipping_delay` | `days_for_shipping_real - days_for_shipment_scheduled` |
| `is_early_or_ontime` | 1 if delay ≤ 0 |
| `order_to_shipping_hours` | Hours between order and shipping |

## Outliers Capped (IQR)

| Column | Outliers | % |
|--------|----------|---|
| `benefit_per_order` | 18,942 | 10.5% |
| `sales_per_customer` | 1,943 | 1.1% |
| `order_item_discount` | 7,537 | 4.2% |
| `order_item_product_price` | 2,048 | 1.1% |
| `order_item_quantity` | 0 | 0.0% |
| `order_profit_per_order` | 18,942 | 10.5% |
| `actual_shipping_delay` | 35,701 | 19.8% |

## Final Audit

| Check | Status |
|-------|--------|
| Missing values | **NONE** |
| Duplicate rows | **0** |
| Negative quantities/prices | **0** |
| Orders shipped before ordered | **0** |
| Single-value columns | **None** (dropped) |

**Output:** `data/supply_chain_cleaned.csv` — **180,519 rows × 62 columns, 102 MB** — ready for analysis.
