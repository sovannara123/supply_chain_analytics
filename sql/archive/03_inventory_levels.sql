-- ============================================================
-- SQL Script 03: Inventory & Product Analysis
-- Supply Chain Control Tower — SQLite syntax
-- Demonstrates: CTEs, window ranking, conditional aggregation
-- ============================================================

-- 1. Product Category Sales & Profitability
SELECT
    category_name,
    department_name,
    COUNT(*) AS order_count,
    COUNT(DISTINCT product_name) AS product_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit_per_order,
    ROUND(SUM(sales) * 1.0 / SUM(SUM(sales)) OVER(), 4) AS sales_share
FROM orders
GROUP BY category_name, department_name
ORDER BY total_sales DESC;

-- 2. ABC Classification by Revenue (70/20/10 rule)
WITH category_revenue AS (
    SELECT
        category_name,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(sales) * 1.0 / SUM(SUM(sales)) OVER(), 4) AS pct_of_total,
        ROUND(SUM(SUM(sales)) OVER (ORDER BY SUM(sales) DESC), 2) AS running_total,
        ROUND(SUM(SUM(sales)) OVER (ORDER BY SUM(sales) DESC) * 1.0 / SUM(SUM(sales)) OVER(), 4) AS running_pct
    FROM orders
    GROUP BY category_name
)
SELECT
    category_name,
    total_sales,
    pct_of_total,
    running_pct,
    CASE
        WHEN running_pct <= 0.70 THEN 'A'
        WHEN running_pct <= 0.90 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM category_revenue
ORDER BY total_sales DESC;

-- 3. Department Performance Ranking
SELECT
    department_name,
    COUNT(*) AS order_count,
    COUNT(DISTINCT product_name) AS product_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(order_item_quantity), 2) AS avg_quantity_per_order,
    ROUND(AVG(order_item_discount), 4) AS avg_discount,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct
FROM orders
GROUP BY department_name
ORDER BY total_profit DESC;

-- 4. Order Status & Financial Loss
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_total,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(sales), 2) AS avg_order_value,
    ROUND(AVG(order_item_discount), 4) AS avg_discount_rate
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 5. Seasonal Demand by Top Product Categories
WITH top_categories AS (
    SELECT category_name
    FROM orders
    GROUP BY category_name
    ORDER BY SUM(sales) DESC
    LIMIT 5
)
SELECT
    o.category_name,
    o.order_season,
    o.order_month,
    COUNT(*) AS order_count,
    ROUND(SUM(o.sales), 2) AS total_sales,
    ROUND(AVG(o.order_item_quantity), 2) AS avg_quantity,
    ROUND(SUM(o.order_profit_per_order), 2) AS total_profit
FROM orders o
INNER JOIN top_categories t ON o.category_name = t.category_name
GROUP BY o.category_name, o.order_season, o.order_month
ORDER BY o.category_name, o.order_month;

-- 6. Product-Level Performance (top 20 by sales)
SELECT
    product_name,
    category_name,
    department_name,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(product_price), 2) AS avg_price,
    ROUND(AVG(order_item_discount), 4) AS avg_discount,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct,
    ROUND(AVG(actual_shipping_delay), 2) AS avg_delay_days
FROM orders
GROUP BY product_name, category_name, department_name
ORDER BY total_sales DESC
LIMIT 20;

-- 7. Customer Segment Product Preferences
SELECT
    customer_segment,
    category_name,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 1.0 / SUM(SUM(sales)) OVER (PARTITION BY customer_segment), 4) AS pct_of_segment_sales
FROM orders
GROUP BY customer_segment, category_name
HAVING COUNT(*) >= 10
ORDER BY customer_segment, total_sales DESC;
