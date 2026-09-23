-- ============================================================
-- SQL Script 01: Executive KPIs
-- Supply Chain Control Tower — PostgreSQL syntax
-- Demonstrates: aggregations, CASE expressions, window functions
-- ============================================================

-- 1. Overall On-Time Delivery (OTD) Rate
SELECT
    ROUND(100.0 * SUM(CASE WHEN delivery_status IN ('Advance shipping', 'Shipping on time') THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_delivery_pct,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_delivery_risk_pct,
    COUNT(*) AS total_orders
FROM fact_order_items;

-- 2. Average Order Lead Times
SELECT
    ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_lead_days,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_actual_lead_days,
    ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled), 2) AS avg_deviation_days,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_shipping_delay_days,
    ROUND(AVG(EXTRACT(EPOCH FROM (shipping_date - order_date)) / 3600.0), 1) AS avg_order_to_shipping_hours
FROM fact_order_items;

-- 3. Monthly KPI Trend (uses window function for running total)
WITH monthly_stats AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS order_year,
        EXTRACT(MONTH FROM order_date) AS order_month,
        COUNT(*) AS total_orders,
        SUM(sales) AS total_sales,
        SUM(order_profit_per_order) AS total_profit,
        SUM(late_delivery_risk) AS late_deliveries
    FROM fact_order_items
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
)
SELECT
    order_year,
    order_month,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(100.0 * late_deliveries / total_orders, 1) AS late_rate_pct,
    ROUND(SUM(total_sales) OVER (ORDER BY order_year, order_month ROWS UNBOUNDED PRECEDING), 2) AS running_total_sales
FROM monthly_stats
ORDER BY order_year, order_month;

-- 4. Late vs On-Time Financial Comparison
SELECT
    CASE WHEN late_delivery_risk = 1 THEN 'Late' ELSE 'On-Time' END AS delivery_category,
    COUNT(*) AS order_count,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(AVG(benefit_per_order), 4) AS avg_benefit_per_order,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(SUM(sales) / SUM(SUM(sales)) OVER(), 4) AS revenue_share
FROM fact_order_items
GROUP BY late_delivery_risk;

-- 5. Executive Summary Dashboard
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(sales), 2) AS avg_order_value,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN delivery_status IN ('Advance shipping', 'Shipping on time') THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_lead_time_days
FROM fact_order_items;
