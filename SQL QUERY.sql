SQL QUERY



-- step to clean the table beacsuse of duplicacy
CREATE TABLE CLEAN_BLINKIT_CTGRY AS SELECT * FROM all_blinkit_category_scraping_stream 
GROUP BY created_at , sku_id , store_id;  	
-- 
select * from CLEAN_BLINKIT_CTGRY;
DROP TABLE all_blinkit_category_scraping_stream ;

ALTER TABLE CLEAN_BLINKIT_CTGRY RENAME TO all_blinkit_category_scraping_stream ;




--DROP TABLE IF EXISTS blinkit_city_insights;
SELECT * FROM blinkit_city_insights ;


--select * from  all_blinkit_category_scraping_stream
CREATE TABLE blinkit_city_insights AS
WITH lagged_data AS (
    SELECT
        *,
        DATE(created_at) AS date,
        LAG(inventory) OVER (PARTITION BY sku_id, store_id ORDER BY created_at) AS prev_inventory
    FROM all_blinkit_category_scraping_stream
),
with_sales AS (
    SELECT
        l.sku_id,
        l.store_id,
        l.date,
        l.created_at,
        l.inventory,
        l.prev_inventory,
        l.selling_price,
        l.mrp,
        l.brand,
        l.brand_id,
        l.sku_name,
        l.image_url,
        l.l1_category_id,
        l.l2_category_id,
        CASE 
            WHEN prev_inventory IS NOT NULL AND prev_inventory > inventory THEN prev_inventory - inventory
            ELSE 0
        END AS est_qty_sold
    FROM lagged_data l
),
joined_with_city AS (
    SELECT w.*, c.city_name
    FROM with_sales w
    JOIN blinkit_city_map c ON w.store_id = c.store_id
),
joined_with_categories AS (
    SELECT j.*, 
           cat.l1_category AS category_name,
           cat.l2_category AS sub_category_name
    FROM joined_with_city j
    LEFT JOIN blinkit_categories cat ON j.l2_category_id = cat.l2_category_id
),
aggregated_insights AS (
    SELECT 
        date,
        sku_id,
        city_name,
        MIN(brand_id) AS brand_id,
        MIN(brand) AS brand,
        MIN(image_url) AS image_url,
        MIN(sku_name) AS sku_name,
        MIN(l1_category_id) AS category_id,
        MIN(category_name) AS category_name,
        MIN(l2_category_id) AS sub_category_id,
        MIN(sub_category_name) AS sub_category_name,
        SUM(est_qty_sold) AS est_qty_sold,
        SUM(est_qty_sold * selling_price) AS est_sales_sp,
        SUM(est_qty_sold * mrp) AS est_sales_mrp,
        COUNT(DISTINCT store_id) AS listed_ds_count
    FROM joined_with_categories
    GROUP BY date, sku_id, city_name
),
store_metrics AS (
    SELECT 
        DATE(created_at) AS date,
        sku_id,
        COUNT(DISTINCT store_id) AS total_store_count,
        SUM(CASE WHEN inventory > 0 THEN 1 ELSE 0 END) AS in_stock_store_count
    FROM all_blinkit_category_scraping_stream
    GROUP BY DATE(created_at), sku_id
)

-- Final Output
SELECT 
    a.*,
    sm.total_store_count AS ds_count,
    ROUND(1.0 * sm.in_stock_store_count / sm.total_store_count, 2) AS wt_osa,
    ROUND(1.0 * sm.in_stock_store_count / a.listed_ds_count, 2) AS wt_osa_ls,

    -- Mode logic approximated as latest price
    (SELECT mrp FROM all_blinkit_category_scraping_stream t 
     WHERE t.sku_id = a.sku_id 
       AND DATE(t.created_at) = a.date 
     ORDER BY t.created_at DESC LIMIT 1) AS mrp,

    (SELECT selling_price FROM all_blinkit_category_scraping_stream t 
     WHERE t.sku_id = a.sku_id 
       AND DATE(t.created_at) = a.date 
     ORDER BY t.created_at DESC LIMIT 1) AS sp,

    ROUND(
        (CAST(
            (SELECT mrp FROM all_blinkit_category_scraping_stream t 
             WHERE t.sku_id = a.sku_id AND DATE(t.created_at) = a.date 
             ORDER BY t.created_at DESC LIMIT 1
            ) AS FLOAT) -
         (SELECT selling_price FROM all_blinkit_category_scraping_stream t 
             WHERE t.sku_id = a.sku_id AND DATE(t.created_at) = a.date 
             ORDER BY t.created_at DESC LIMIT 1
         )
        ) / 
        (SELECT mrp FROM all_blinkit_category_scraping_stream t 
         WHERE t.sku_id = a.sku_id AND DATE(t.created_at) = a.date 
         ORDER BY t.created_at DESC LIMIT 1
        ), 2
    ) AS discount

FROM aggregated_insights a
JOIN store_metrics sm
  ON a.date = sm.date AND a.sku_id = sm.sku_id;