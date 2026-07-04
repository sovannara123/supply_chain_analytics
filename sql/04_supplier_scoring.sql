-- ============================================================
-- SQL Script 04: Supplier Performance Scoring
-- Supply Chain Control Tower — SQLite syntax
-- Demonstrates: CTEs, ranking, derived metrics, Pareto analysis
-- ============================================================

-- Note: DataCo dataset has no explicit supplier_id column.
-- Supplier proxy = order_city | order_country (origin location).
-- See notebook 05 for methodology details.

-- 1. Supplier (Origin) Composite Performance Score
WITH supplier_metrics AS (
    SELECT
        order_city || ' | ' || order_country AS supplier_origin,
        COUNT(*) AS total_orders,
        ROUND(100.0 * SUM(CASE WHEN late_delivery_risk = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_rate,
        ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
        ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled), 2) AS avg_schedule_deviation,
        ROUND(SQRT(AVG(days_for_shipping_real*days_for_shipping_real) - AVG(days_for_shipping_real)*AVG(days_for_shipping_real)), 2) AS lead_time_stddev,
        COUNT(DISTINCT product_name) AS product_breadth,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(order_profit_per_order), 2) AS total_profit
    FROM orders
    GROUP BY order_city, order_country
    HAVING COUNT(*) >= 5
)
SELECT
    supplier_origin,
    total_orders,
    on_time_rate,
    avg_delay_days,
    lead_time_stddev,
    product_breadth,
    total_sales,
    -- Composite score: 40% on-time rate, 30% low delay, 20% consistency, 10% breadth
    ROUND(
        0.40 * (on_time_rate / 100.0)
        + 0.30 * (1.0 - MIN(avg_delay_days, 10) / 10.0)
        + 0.20 * (1.0 - MIN(lead_time_stddev, 5) / 5.0)
        + 0.10 * (MIN(product_breadth, 50) / 50.0)
    , 4) AS composite_score,
    RANK() OVER (ORDER BY
        0.40 * (on_time_rate / 100.0)
        + 0.30 * (1.0 - MIN(avg_delay_days, 10) / 10.0)
        + 0.20 * (1.0 - MIN(lead_time_stddev, 5) / 5.0)
        + 0.10 * (MIN(product_breadth, 50) / 50.0)
    DESC) AS score_rank
FROM supplier_metrics
ORDER BY composite_score DESC
LIMIT 30;

-- 2. Pareto Analysis: Top 20% Origins → % of Late Orders
WITH origin_late AS (
    SELECT
        order_city || ' | ' || order_country AS supplier_origin,
        SUM(late_delivery_risk) AS late_orders,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY order_city, order_country
),
cumulative AS (
    SELECT
        supplier_origin,
        late_orders,
        total_orders,
        SUM(late_orders) OVER (ORDER BY late_orders DESC) AS running_late,
        SUM(late_orders) OVER () AS total_late_orders,
        ROW_NUMBER() OVER (ORDER BY late_orders DESC) AS row_num,
        COUNT(*) OVER () AS total_origins
    FROM origin_late
)
SELECT
    'Top 20% origins' AS segment,
    COUNT(*) AS origin_count,
    ROUND(100.0 * COUNT(*) / MAX(total_origins), 1) AS pct_of_origins,
    SUM(late_orders) AS late_orders,
    ROUND(100.0 * SUM(late_orders) / MAX(total_late_orders), 1) AS pct_of_all_late_orders
FROM cumulative
WHERE row_num <= ROUND(total_origins * 0.20);

-- 3. Lead Time Consistency Ranking
SELECT
    order_city || ' | ' || order_country AS supplier_origin,
    COUNT(*) AS total_orders,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_lead_days,
    ROUND(SQRT(AVG(days_for_shipping_real*days_for_shipping_real) - AVG(days_for_shipping_real)*AVG(days_for_shipping_real)), 2) AS lead_time_stddev,
    ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_days,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct
FROM orders
GROUP BY order_city, order_country
HAVING COUNT(*) >= 10
ORDER BY lead_time_stddev ASC
LIMIT 20;

-- 4. Product Risk Scoring by Origin
SELECT
    product_name,
    order_city || ' | ' || order_country AS supplier_origin,
    COUNT(*) AS order_count,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(SUM(sales), 2) AS total_sales,
    -- Risk score: higher = riskier (late_rate * 0.6 + normalized_delay * 0.4)
    ROUND(
        0.6 * (100.0 * SUM(late_delivery_risk) / COUNT(*))
        + 0.4 * AVG(actual_shipping_delay) * 10
    , 1) AS risk_score
FROM orders
GROUP BY product_name, order_city, order_country
HAVING COUNT(*) >= 5
ORDER BY risk_score DESC
LIMIT 20;

-- 5. Supplier Performance by Category
SELECT
    category_name,
    order_city || ' | ' || order_country AS supplier_origin,
    COUNT(*) AS order_count,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit
FROM orders
GROUP BY category_name, order_city, order_country
HAVING COUNT(*) >= 5
ORDER BY category_name, late_rate_pct ASC;
