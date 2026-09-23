-- ============================================================
-- SQL Script 03: Build Star Schema (Curated Layer)
-- Extracts dimensions and facts from raw flat table
-- ============================================================

-- 1. Create dim_customer (Excludes customer_password for security)
DROP TABLE IF EXISTS dim_customer CASCADE;
CREATE TABLE dim_customer AS
SELECT DISTINCT
    customer_id,
    customer_fname,
    customer_lname,
    customer_email,
    customer_segment,
    customer_street,
    customer_city,
    customer_state,
    customer_country,
    customer_zipcode
FROM datacosupplychaindataset;

ALTER TABLE dim_customer ADD PRIMARY KEY (customer_id);

-- 2. Create dim_product
DROP TABLE IF EXISTS dim_product CASCADE;
CREATE TABLE dim_product AS
SELECT DISTINCT
    product_card_id,
    product_name,
    product_description,
    product_image,
    product_price,
    product_status,
    product_category_id,
    category_name,
    department_id,
    department_name
FROM datacosupplychaindataset;

ALTER TABLE dim_product ADD PRIMARY KEY (product_card_id);

-- 3. Create fact_order_items
DROP TABLE IF EXISTS fact_order_items CASCADE;
CREATE TABLE fact_order_items AS
SELECT
    order_item_id,
    order_id,
    order_date,
    shipping_date,
    order_customer_id AS customer_id,
    order_item_cardprod_id AS product_card_id,
    type AS transaction_type,
    sales,
    order_item_quantity,
    order_item_discount,
    order_item_discount_rate,
    order_item_product_price,
    order_item_profit_ratio,
    order_item_total,
    order_profit_per_order,
    benefit_per_order,
    shipping_mode,
    delivery_status,
    late_delivery_risk,
    days_for_shipping_real,
    days_for_shipment_scheduled,
    (days_for_shipping_real - days_for_shipment_scheduled) AS actual_shipping_delay,
    order_city,
    order_state,
    order_country,
    order_region,
    order_zipcode,
    market,
    latitude,
    longitude
FROM datacosupplychaindataset;

ALTER TABLE fact_order_items ADD PRIMARY KEY (order_item_id);

-- 4. Add Indexes for performance
CREATE INDEX idx_fact_order_date ON fact_order_items (order_date);
CREATE INDEX idx_fact_customer_id ON fact_order_items (customer_id);
CREATE INDEX idx_fact_product_id ON fact_order_items (product_card_id);
CREATE INDEX idx_fact_shipping_mode ON fact_order_items (shipping_mode);
CREATE INDEX idx_fact_delivery_status ON fact_order_items (delivery_status);

-- 5. Grant permissions to analyst user
GRANT SELECT ON dim_customer TO analyst_user;
GRANT SELECT ON dim_product TO analyst_user;
GRANT SELECT ON fact_order_items TO analyst_user;
