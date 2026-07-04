-- ============================================================
-- SQL Script 01: Executive KPIs
-- Supply Chain Control Tower — SQLite syntax
-- Demonstrates: aggregations, CASE expressions, window functions
-- ============================================================

-- Create the main orders table (run once)
-- NOTE: Create the orders table before running queries.

-- 1. Overall On-Time Delivery (OTD) Rate
SELECT
    ROUND(100.0 * SUM(CASE WHEN delivery_status IN ('Advance shipping', 'Shipping on time') THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_delivery_pct,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_delivery_risk_pct,
    COUNT(*) AS total_orders
FROM orders;

-- 2. Average Order Lead Times
SELECT
    ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_lead_days,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_actual_lead_days,
    ROUND(AVG(days_for_shipping_real - days_for_shipment_scheduled), 2) AS avg_deviation_days,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_shipping_delay_days,
    ROUND(AVG(COALESCE(NULLIF(order_to_shipping_hours, 0), 0)), 1) AS avg_order_to_shipping_hours
FROM orders;

-- 3. Monthly KPI Trend (uses window function for running total)
SELECT
    order_year,
    order_month,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(SUM(SUM(sales)) OVER (ORDER BY order_year, order_month ROWS UNBOUNDED PRECEDING), 2) AS running_total_sales
FROM orders
GROUP BY order_year, order_month
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
    ROUND(SUM(sales) * 1.0 / SUM(SUM(sales)) OVER(), 4) AS revenue_share
FROM orders
GROUP BY late_delivery_risk;

-- 5. Order Status Breakdown (lost revenue from bad statuses)
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS pct_total,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 6. Executive Summary Dashboard
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(sales), 2) AS avg_order_value,
    ROUND(SUM(CASE WHEN order_status IN ('CANCELED', 'SUSPECTED_FRAUD') THEN sales ELSE 0 END), 2) AS lost_revenue,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN delivery_status IN ('Advance shipping', 'Shipping on time') THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct,
    ROUND(AVG(days_for_shipping_real), 2) AS avg_lead_time_days
FROM orders;
