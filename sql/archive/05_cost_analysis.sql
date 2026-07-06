-- ============================================================
-- SQL Script 05: Cost & Profitability Analysis
-- Supply Chain Control Tower — SQLite / PostgreSQL syntax
-- Demonstrates: CTEs, ratio analysis, conditional aggregation
-- ============================================================

-- 1. Profitability by Shipping Mode
SELECT
    shipping_mode,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit_per_order,
    ROUND(SUM(order_profit_per_order) / NULLIF(SUM(sales), 0), 4) AS profit_margin_ratio,
    ROUND(AVG(order_item_discount), 4) AS avg_discount_rate,
    ROUND(AVG(benefit_per_order), 4) AS avg_benefit_per_order
FROM orders
GROUP BY shipping_mode
ORDER BY total_profit DESC;

-- 2. Discount Impact on Profitability
SELECT
    CASE
        WHEN order_item_discount_rate = 0 THEN 'No Discount'
        WHEN order_item_discount_rate <= 0.05 THEN 'Low (0-5%)'
        WHEN order_item_discount_rate <= 0.15 THEN 'Medium (5-15%)'
        WHEN order_item_discount_rate <= 0.30 THEN 'High (15-30%)'
        ELSE 'Extreme (>30%)'
    END AS discount_tier,
    COUNT(*) AS order_count,
    ROUND(AVG(order_item_discount_rate), 4) AS avg_discount_rate,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(AVG(benefit_per_order), 4) AS avg_benefit,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct
FROM orders
GROUP BY discount_tier
ORDER BY avg_discount_rate;

-- 3. Customer Segment Profitability
SELECT
    customer_segment,
    COUNT(*) AS order_count,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT customer_id), 0), 2) AS revenue_per_customer,
    ROUND(AVG(order_item_quantity), 2) AS avg_quantity,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct
FROM orders
GROUP BY customer_segment
ORDER BY total_profit DESC;

-- 4. Late Delivery Cost Impact (profit loss attribution)
WITH delivery_profit AS (
    SELECT
        CASE WHEN late_delivery_risk = 1 THEN 'Late' ELSE 'On-Time' END AS delivery_type,
        COUNT(*) AS order_count,
        ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
        ROUND(AVG(sales), 2) AS avg_sales,
        ROUND(AVG(benefit_per_order), 4) AS avg_benefit,
        ROUND(AVG(order_item_discount), 4) AS avg_discount
    FROM orders
    GROUP BY late_delivery_risk
)
SELECT
    delivery_type,
    order_count,
    avg_profit,
    avg_sales,
    avg_benefit,
    avg_discount,
    ROUND(avg_profit - LAG(avg_profit) OVER (ORDER BY delivery_type), 2) AS profit_diff_from_ontime,
    ROUND((avg_profit - LAG(avg_profit) OVER (ORDER BY delivery_type)) / NULLIF(LAG(avg_profit) OVER (ORDER BY delivery_type), 0) * 100, 1) AS profit_pct_change
FROM delivery_profit;

-- 5. Category × Market Profitability Matrix
SELECT
    category_name,
    market,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(SUM(order_profit_per_order) / NULLIF(SUM(sales), 0), 4) AS profit_margin,
    ROUND(AVG(order_item_discount_rate), 4) AS avg_discount_rate
FROM orders
GROUP BY category_name, market
HAVING COUNT(*) >= 10
ORDER BY total_profit DESC
LIMIT 30;

-- 6. Product Price Tier Analysis
SELECT
    CASE
        WHEN product_price < 50 THEN 'Budget (<$50)'
        WHEN product_price < 150 THEN 'Mid-Range ($50-$149)'
        WHEN product_price < 500 THEN 'Premium ($150-$499)'
        ELSE 'Luxury ($500+)'
    END AS price_tier,
    COUNT(*) AS order_count,
    ROUND(AVG(product_price), 2) AS avg_price,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(AVG(order_item_discount_rate), 4) AS avg_discount_rate,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct
FROM orders
GROUP BY price_tier
ORDER BY avg_price;

-- 7. Order Quantity Impact on Profitability
SELECT
    CASE
        WHEN order_item_quantity = 1 THEN 'Single Item'
        WHEN order_item_quantity <= 3 THEN 'Small (2-3)'
        WHEN order_item_quantity <= 6 THEN 'Medium (4-6)'
        ELSE 'Bulk (7+)'
    END AS order_size_tier,
    COUNT(*) AS order_count,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(AVG(order_item_discount_rate), 4) AS avg_discount_rate,
    ROUND(AVG(benefit_per_order), 4) AS avg_benefit,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 1) AS late_rate_pct
FROM orders
GROUP BY order_size_tier
ORDER BY MIN(order_item_quantity);
