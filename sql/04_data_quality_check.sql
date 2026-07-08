-- ============================================================
-- Data Quality Check: datacosupplychaindataset
-- Run: psql -d supply_chain -f sql/04_data_quality_check.sql
-- ============================================================

-- 1. Row count
SELECT 'Row Count' AS check_name, COUNT(*)::TEXT AS result FROM datacosupplychaindataset;

-- 2. Column count
SELECT 'Column Count' AS check_name, COUNT(*)::TEXT AS result
FROM information_schema.columns
WHERE table_name = 'datacosupplychaindataset';

-- 3. Null counts per column
SELECT 'Null Counts' AS check_name, jsonb_agg(col_nulls)::TEXT AS result
FROM (
    SELECT jsonb_build_object(column_name, null_count) AS col_nulls
    FROM (
        SELECT 'order_id' AS column_name, COUNT(*) FILTER (WHERE order_id IS NULL) AS null_count FROM datacosupplychaindataset
        UNION ALL SELECT 'order_date', COUNT(*) FILTER (WHERE order_date IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'shipping_date', COUNT(*) FILTER (WHERE shipping_date IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'order_zipcode', COUNT(*) FILTER (WHERE order_zipcode IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'product_description', COUNT(*) FILTER (WHERE product_description IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'customer_email', COUNT(*) FILTER (WHERE customer_email IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'customer_password', COUNT(*) FILTER (WHERE customer_password IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'customer_lname', COUNT(*) FILTER (WHERE customer_lname IS NULL) FROM datacosupplychaindataset
        UNION ALL SELECT 'customer_zipcode', COUNT(*) FILTER (WHERE customer_zipcode IS NULL) FROM datacosupplychaindataset
    ) _
    WHERE null_count > 0
) __;

-- 4. Duplicate rows (by composite key)
SELECT 'Duplicate Rows (order_id + order_item_id + product_card_id)' AS check_name,
       (COUNT(*) - COUNT(DISTINCT (order_id::TEXT || '|' || order_item_id::TEXT || '|' || product_card_id::TEXT)))::TEXT AS result
FROM datacosupplychaindataset;

-- 5. Duplicate order_ids
SELECT 'Duplicate order_ids' AS check_name, COUNT(*)::TEXT AS result
FROM (SELECT order_id FROM datacosupplychaindataset GROUP BY order_id HAVING COUNT(*) > 1) _;

-- 6. Date integrity (shipped before ordered)
SELECT 'Shipped before ordered' AS check_name, COUNT(*)::TEXT AS result
FROM datacosupplychaindataset
WHERE shipping_date < order_date;

-- 7. Date range
SELECT 'Order date range' AS check_name, MIN(order_date)::TEXT || ' to ' || MAX(order_date)::TEXT AS result
FROM datacosupplychaindataset
UNION ALL
SELECT 'Shipping date range', MIN(shipping_date)::TEXT || ' to ' || MAX(shipping_date)::TEXT
FROM datacosupplychaindataset;

-- 8. Negative / suspicious values
SELECT 'Negative benefit_per_order' AS check_name, COUNT(*)::TEXT AS result FROM datacosupplychaindataset WHERE benefit_per_order < 0
UNION ALL
SELECT 'Zero/negative sales', COUNT(*)::TEXT FROM datacosupplychaindataset WHERE sales <= 0
UNION ALL
SELECT 'Zero order_item_quantity', COUNT(*)::TEXT FROM datacosupplychaindataset WHERE order_item_quantity <= 0
UNION ALL
SELECT 'Negative order_profit_per_order', COUNT(*)::TEXT FROM datacosupplychaindataset WHERE order_profit_per_order < 0
UNION ALL
SELECT 'Future order_dates', COUNT(*)::TEXT FROM datacosupplychaindataset WHERE order_date > CURRENT_DATE;

-- 9. Categorical value distribution (key columns)
SELECT 'Shipping modes' AS check_name, jsonb_agg(jsonb_build_object(mode, cnt))::TEXT AS result
FROM (SELECT shipping_mode AS mode, COUNT(*) AS cnt FROM datacosupplychaindataset GROUP BY shipping_mode ORDER BY cnt DESC) _
UNION ALL
SELECT 'Delivery statuses', jsonb_agg(jsonb_build_object(status, cnt))::TEXT
FROM (SELECT delivery_status AS status, COUNT(*) AS cnt FROM datacosupplychaindataset GROUP BY delivery_status ORDER BY cnt DESC) _
UNION ALL
SELECT 'Order statuses', jsonb_agg(jsonb_build_object(status, cnt))::TEXT
FROM (SELECT order_status AS status, COUNT(*) AS cnt FROM datacosupplychaindataset GROUP BY order_status ORDER BY cnt DESC) _
UNION ALL
SELECT 'Markets', jsonb_agg(jsonb_build_object(market, cnt))::TEXT
FROM (SELECT market, COUNT(*) AS cnt FROM datacosupplychaindataset GROUP BY market ORDER BY cnt DESC) _;

-- 10. Late delivery rate
SELECT 'Late delivery rate (%)' AS check_name, ROUND(AVG(late_delivery_risk) * 100, 1)::TEXT AS result
FROM datacosupplychaindataset;

-- 11. Column uniqueness (cardinality)
SELECT 'Unique customers' AS check_name, COUNT(DISTINCT customer_id)::TEXT AS result FROM datacosupplychaindataset
UNION ALL
SELECT 'Unique products', COUNT(DISTINCT product_card_id)::TEXT FROM datacosupplychaindataset
UNION ALL
SELECT 'Unique order_items', COUNT(DISTINCT order_item_id)::TEXT FROM datacosupplychaindataset
UNION ALL
SELECT 'Unique shipping_modes', COUNT(DISTINCT shipping_mode)::TEXT FROM datacosupplychaindataset;
