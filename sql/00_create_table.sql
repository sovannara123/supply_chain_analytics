-- ============================================================
-- SQL Script 00: Create & Import DataCoSupplyChainDataset
-- PostgreSQL via pgAdmin / psql
-- Column order matches CSV ordinal position for \copy import
-- ============================================================

-- 1. Create database (run once in pgAdmin Query Tool or psql)
CREATE DATABASE supply_chain;

-- 2. Create the table (column order = CSV column order)
CREATE TABLE datacosupplychaindataset (
    type                    VARCHAR(20),
    days_for_shipping_real  INTEGER,
    days_for_shipment_scheduled INTEGER,
    benefit_per_order       NUMERIC(10,2),
    sales_per_customer      NUMERIC(10,4),
    delivery_status         VARCHAR(50),
    late_delivery_risk      SMALLINT,
    category_id             INTEGER,
    category_name           VARCHAR(100),
    customer_city           VARCHAR(100),
    customer_country        VARCHAR(100),
    customer_email          VARCHAR(100),
    customer_fname          VARCHAR(100),
    customer_id             INTEGER,
    customer_lname          VARCHAR(100),
    customer_password       VARCHAR(100),
    customer_segment        VARCHAR(50),
    customer_state          VARCHAR(50),
    customer_street         VARCHAR(200),
    customer_zipcode        VARCHAR(20),
    department_id           INTEGER,
    department_name         VARCHAR(100),
    latitude                NUMERIC(10,6),
    longitude               NUMERIC(10,6),
    market                  VARCHAR(50),
    order_city              VARCHAR(100),
    order_country           VARCHAR(100),
    order_customer_id       INTEGER,
    order_date              TIMESTAMP,
    order_id                INTEGER,
    order_item_cardprod_id  INTEGER,
    order_item_discount     NUMERIC(10,4),
    order_item_discount_rate NUMERIC(10,4),
    order_item_id           INTEGER,
    order_item_product_price NUMERIC(10,2),
    order_item_profit_ratio NUMERIC(10,4),
    order_item_quantity     INTEGER,
    sales                   NUMERIC(10,2),
    order_item_total        NUMERIC(10,4),
    order_profit_per_order  NUMERIC(10,2),
    order_region            VARCHAR(100),
    order_state             VARCHAR(100),
    order_status            VARCHAR(50),
    order_zipcode           VARCHAR(20),
    product_card_id         INTEGER,
    product_category_id     INTEGER,
    product_description     TEXT,
    product_image           TEXT,
    product_name            VARCHAR(200),
    product_price           NUMERIC(10,2),
    product_status          SMALLINT,
    shipping_date           TIMESTAMP,
    shipping_mode           VARCHAR(50)
);

-- 3. Import CSV data (run in psql, NOT pgAdmin)
--    Replace '/path/to/' with the actual path to the CSV file
--
--    psql -d supply_chain -f sql/00_create_table.sql
--
--    Then run the \copy command separately:
--    \copy datacosupplychaindataset FROM '/path/to/data/DataCoSupplyChainDataset.csv' WITH CSV HEADER DELIMITER ',' ENCODING 'LATIN1'

-- 4. Add indexes for faster queries
CREATE INDEX idx_order_date ON datacosupplychaindataset (order_date);
CREATE INDEX idx_shipping_date ON datacosupplychaindataset (shipping_date);
CREATE INDEX idx_shipping_mode ON datacosupplychaindataset (shipping_mode);
CREATE INDEX idx_order_status ON datacosupplychaindataset (order_status);
CREATE INDEX idx_late_delivery_risk ON datacosupplychaindataset (late_delivery_risk);
CREATE INDEX idx_order_city ON datacosupplychaindataset (order_city);
CREATE INDEX idx_order_country ON datacosupplychaindataset (order_country);
CREATE INDEX idx_customer_id ON datacosupplychaindataset (customer_id);
CREATE INDEX idx_product_name ON datacosupplychaindataset (product_name);

-- 5. Verify import
SELECT COUNT(*) AS total_rows FROM datacosupplychaindataset;

-- 6. Create analysis_ready view (curated columns for analysis)
CREATE VIEW analysis_ready AS
SELECT
    order_id,
    shipping_mode,
    days_for_shipping_real,
    days_for_shipment_scheduled,
    (days_for_shipping_real - days_for_shipment_scheduled) AS actual_shipping_delay,
    CASE WHEN days_for_shipping_real <= days_for_shipment_scheduled THEN 1 ELSE 0 END AS is_early_or_ontime,
    order_city,
    order_country,
    order_region,
    market,
    category_name,
    department_name,
    product_name,
    customer_segment,
    customer_id,
    sales,
    order_profit_per_order,
    order_item_discount,
    order_status,
    delivery_status,
    late_delivery_risk,
    type,
    order_date,
    shipping_date
FROM datacosupplychaindataset;

-- 7. Grant permissions to analyst user
GRANT SELECT ON datacosupplychaindataset TO analyst_user;
GRANT SELECT ON analysis_ready TO analyst_user;
