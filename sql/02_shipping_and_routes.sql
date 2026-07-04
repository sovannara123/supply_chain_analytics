-- ============================================================
-- SQL Script 02: Shipping & Route Analysis
-- Supply Chain Control Tower — SQLite syntax
-- Demonstrates: CTEs, window functions, multi-level aggregation
-- ============================================================

-- 1. Shipping Mode Performance Comparison
SELECT
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(100.0 * SUM(CASE WHEN late_delivery_risk = 0 THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_actual_lead_days,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit
FROM orders
GROUP BY shipping_mode
ORDER BY on_time_pct DESC;

-- 2. Market × Region Delay Heatmap Data
SELECT
    market,
    order_region,
    COUNT(*) AS total_orders,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_lead_days,
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
GROUP BY market, order_region
ORDER BY late_rate_pct DESC;

-- 3. Top 10 Most Delay-Prone Origin Cities
SELECT
    order_city,
    order_country,
    order_region,
    COUNT(*) AS total_orders,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_lead_days
FROM orders
GROUP BY order_city, order_country, order_region
HAVING COUNT(*) >= 50
ORDER BY late_rate_pct DESC
LIMIT 10;

-- 4. Shipping Mode × Market Interaction
WITH mode_market_stats AS (
    SELECT
        shipping_mode,
        market,
        COUNT(*) AS total_orders,
        ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
        ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
        ROUND(SUM(sales), 2) AS total_sales
    FROM orders
    GROUP BY shipping_mode, market
)
SELECT
    shipping_mode,
    market,
    total_orders,
    late_rate_pct,
    avg_delay_days,
    total_sales,
    ROUND(total_sales * 1.0 / SUM(total_sales) OVER (PARTITION BY shipping_mode), 4) AS pct_of_mode_sales
FROM mode_market_stats
WHERE total_orders >= 20
ORDER BY shipping_mode, late_rate_pct DESC;

-- 5. Geographic Late Rate Summary (by country)
SELECT
    order_country,
    COUNT(*) AS total_orders,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit
FROM orders
GROUP BY order_country
HAVING COUNT(*) >= 10
ORDER BY late_rate_pct DESC;

-- 6. Delivery Performance by Customer Segment
SELECT
    customer_segment,
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
GROUP BY customer_segment, shipping_mode
ORDER BY customer_segment, late_rate_pct;
