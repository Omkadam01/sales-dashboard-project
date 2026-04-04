-- ============================================================
-- PROJECT 1: BUSINESS SALES DASHBOARD
-- SQL Queries — All KPIs, aggregations & business insights
-- Compatible with: PostgreSQL, MySQL 8+, SQLite, BigQuery
-- Table: sales  (mirrors sales_data.csv structure)
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- TABLE DEFINITION (run once to create)
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sales (
    order_id    VARCHAR(10) PRIMARY KEY,
    date        DATE        NOT NULL,
    year        INT         NOT NULL,
    month       INT         NOT NULL,
    quarter     VARCHAR(2)  NOT NULL,
    region      VARCHAR(10) NOT NULL,
    product     VARCHAR(20) NOT NULL,
    category    VARCHAR(20) NOT NULL,
    salesperson VARCHAR(10) NOT NULL,
    quantity    INT         NOT NULL,
    unit_price  NUMERIC(12,2) NOT NULL,
    revenue     NUMERIC(14,2) NOT NULL,
    cogs        NUMERIC(14,2) NOT NULL,
    profit      NUMERIC(14,2) NOT NULL,
    customer_id VARCHAR(10) NOT NULL
);


-- ============================================================
-- SECTION 1: EXECUTIVE KPIs
-- ============================================================

-- 1a. Overall KPI Summary
SELECT
    COUNT(*)                                          AS total_orders,
    COUNT(DISTINCT customer_id)                       AS unique_customers,
    ROUND(SUM(revenue), 0)                            AS total_revenue,
    ROUND(SUM(profit), 0)                             AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)     AS profit_margin_pct,
    ROUND(AVG(revenue), 0)                            AS avg_order_value,
    ROUND(SUM(quantity), 0)                           AS total_units_sold
FROM sales;


-- 1b. YoY Comparison
SELECT
    year,
    COUNT(*)                                             AS orders,
    ROUND(SUM(revenue), 0)                               AS revenue,
    ROUND(SUM(profit), 0)                                AS profit,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)         AS margin_pct,
    ROUND(AVG(revenue), 0)                               AS avg_order_value
FROM sales
GROUP BY year
ORDER BY year;


-- 1c. YoY Revenue Growth (window function)
WITH yearly AS (
    SELECT
        year,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY year
)
SELECT
    year,
    ROUND(revenue, 0)                                                AS revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year)) * 100.0
        / LAG(revenue) OVER (ORDER BY year), 2
    )                                                                AS yoy_growth_pct
FROM yearly
ORDER BY year;


-- ============================================================
-- SECTION 2: QUARTERLY TREND ANALYSIS
-- ============================================================

-- 2a. Revenue & Profit by Quarter
SELECT
    year,
    quarter,
    CONCAT(year, '-', quarter)                           AS period,
    COUNT(*)                                             AS orders,
    ROUND(SUM(revenue), 0)                               AS revenue,
    ROUND(SUM(profit), 0)                                AS profit,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)         AS margin_pct
FROM sales
GROUP BY year, quarter
ORDER BY year, quarter;


-- 2b. QoQ Revenue Growth
WITH quarterly AS (
    SELECT
        CONCAT(year, '-', quarter) AS period,
        year, quarter,
        SUM(revenue)               AS revenue
    FROM sales
    GROUP BY year, quarter
)
SELECT
    period,
    ROUND(revenue, 0)                                                    AS revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, quarter)) * 100.0
        / LAG(revenue) OVER (ORDER BY year, quarter), 2
    )                                                                    AS qoq_growth_pct
FROM quarterly
ORDER BY year, quarter;


-- 2c. Monthly Revenue Trend
SELECT
    year,
    month,
    TO_CHAR(DATE_TRUNC('month', date), 'Mon YYYY')       AS month_label,  -- PostgreSQL
    COUNT(*)                                             AS orders,
    ROUND(SUM(revenue), 0)                               AS revenue,
    ROUND(SUM(profit), 0)                                AS profit,
    ROUND(AVG(revenue), 0)                               AS avg_order_value
FROM sales
GROUP BY year, month, DATE_TRUNC('month', date)
ORDER BY year, month;


-- ============================================================
-- SECTION 3: REGION ANALYSIS
-- ============================================================

-- 3a. Region Performance Summary
SELECT
    region,
    COUNT(*)                                             AS orders,
    COUNT(DISTINCT customer_id)                          AS unique_customers,
    ROUND(SUM(revenue), 0)                               AS revenue,
    ROUND(SUM(profit), 0)                                AS profit,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)         AS margin_pct,
    ROUND(AVG(revenue), 0)                               AS avg_order_value,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (), 2) AS revenue_share_pct
FROM sales
GROUP BY region
ORDER BY revenue DESC;


-- 3b. Region × Year Pivot
SELECT
    region,
    ROUND(SUM(CASE WHEN year = 2022 THEN revenue ELSE 0 END), 0)  AS rev_2022,
    ROUND(SUM(CASE WHEN year = 2023 THEN revenue ELSE 0 END), 0)  AS rev_2023,
    ROUND(
        (SUM(CASE WHEN year = 2023 THEN revenue ELSE 0 END)
         - SUM(CASE WHEN year = 2022 THEN revenue ELSE 0 END)) * 100.0
        / NULLIF(SUM(CASE WHEN year = 2022 THEN revenue ELSE 0 END), 0), 2
    )                                                             AS yoy_growth_pct
FROM sales
GROUP BY region
ORDER BY rev_2023 DESC;


-- 3c. Best-Performing Region-Quarter Combinations
SELECT
    region,
    CONCAT(year, '-', quarter)   AS period,
    ROUND(SUM(revenue), 0)       AS revenue,
    ROUND(SUM(profit), 0)        AS profit,
    RANK() OVER (PARTITION BY CONCAT(year, '-', quarter)
                 ORDER BY SUM(revenue) DESC) AS rank_in_quarter
FROM sales
GROUP BY region, year, quarter
ORDER BY period, rank_in_quarter;


-- ============================================================
-- SECTION 4: PRODUCT ANALYSIS
-- ============================================================

-- 4a. Product Performance Summary
SELECT
    product,
    category,
    COUNT(*)                                              AS orders,
    SUM(quantity)                                         AS units_sold,
    ROUND(SUM(revenue), 0)                                AS revenue,
    ROUND(SUM(profit), 0)                                 AS profit,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)          AS margin_pct,
    ROUND(AVG(unit_price), 0)                             AS avg_unit_price,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (), 2) AS revenue_share_pct
FROM sales
GROUP BY product, category
ORDER BY revenue DESC;


-- 4b. Category-level Rollup
SELECT
    category,
    COUNT(*)                                              AS orders,
    ROUND(SUM(revenue), 0)                                AS revenue,
    ROUND(SUM(profit), 0)                                 AS profit,
    ROUND(SUM(profit) * 100.0 / SUM(revenue), 2)          AS margin_pct
FROM sales
GROUP BY category
ORDER BY revenue DESC;


-- 4c. Seasonal Product Demand (Q4 vs rest of year)
SELECT
    product,
    ROUND(SUM(CASE WHEN quarter = 'Q4' THEN revenue ELSE 0 END), 0)  AS q4_revenue,
    ROUND(SUM(CASE WHEN quarter != 'Q4' THEN revenue ELSE 0 END)
          / 3.0, 0)                                                   AS avg_other_quarter_revenue,
    ROUND(
        (SUM(CASE WHEN quarter = 'Q4' THEN revenue ELSE 0 END)
         - SUM(CASE WHEN quarter != 'Q4' THEN revenue ELSE 0 END) / 3.0)
        * 100.0
        / NULLIF(SUM(CASE WHEN quarter != 'Q4' THEN revenue ELSE 0 END) / 3.0, 0), 2
    )                                                                 AS q4_uplift_pct
FROM sales
GROUP BY product
ORDER BY q4_uplift_pct DESC;


-- ============================================================
-- SECTION 5: SALESPERSON ANALYSIS
-- ============================================================

-- 5a. Salesperson Leaderboard
SELECT
    salesperson,
    COUNT(*)                                              AS orders,
    COUNT(DISTINCT customer_id)                           AS unique_customers,
    ROUND(SUM(revenue), 0)                                AS revenue,
    ROUND(SUM(profit), 0)                                 AS profit,
    ROUND(AVG(revenue), 0)                                AS avg_order_value,
    RANK() OVER (ORDER BY SUM(revenue) DESC)              AS revenue_rank
FROM sales
GROUP BY salesperson
ORDER BY revenue DESC;


-- ============================================================
-- SECTION 6: CUSTOMER ANALYSIS
-- ============================================================

-- 6a. Customer Segmentation by Revenue
SELECT
    customer_id,
    COUNT(*)                   AS orders,
    ROUND(SUM(revenue), 0)     AS total_revenue,
    ROUND(AVG(revenue), 0)     AS avg_order_value,
    MIN(date)                  AS first_order,
    MAX(date)                  AS last_order,
    NTILE(4) OVER (ORDER BY SUM(revenue) DESC) AS revenue_quartile
FROM sales
GROUP BY customer_id
ORDER BY total_revenue DESC;


-- 6b. Repeat vs One-time Customers
SELECT
    CASE WHEN orders = 1 THEN 'One-time' ELSE 'Repeat' END  AS customer_type,
    COUNT(*)                                                  AS customers,
    ROUND(AVG(total_revenue), 0)                              AS avg_revenue
FROM (
    SELECT customer_id, COUNT(*) AS orders, SUM(revenue) AS total_revenue
    FROM sales
    GROUP BY customer_id
) t
GROUP BY customer_type;


-- ============================================================
-- SECTION 7: BUSINESS INSIGHT QUERIES
-- ============================================================

-- 7a. Which region × product combination generates most profit?
SELECT
    region,
    product,
    ROUND(SUM(profit), 0)   AS total_profit,
    ROUND(SUM(revenue), 0)  AS total_revenue
FROM sales
GROUP BY region, product
ORDER BY total_profit DESC
LIMIT 10;


-- 7b. Q3 drop investigation — month-level detail
SELECT
    year,
    month,
    ROUND(SUM(revenue), 0)  AS revenue,
    ROUND(SUM(profit), 0)   AS profit,
    COUNT(*)                AS orders
FROM sales
WHERE quarter = 'Q3'
GROUP BY year, month
ORDER BY year, month;


-- 7c. Running cumulative revenue by month (YTD)
SELECT
    year,
    month,
    ROUND(SUM(revenue), 0)                                         AS monthly_revenue,
    ROUND(SUM(SUM(revenue)) OVER (PARTITION BY year
                                  ORDER BY month
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS ytd_revenue
FROM sales
GROUP BY year, month
ORDER BY year, month;


-- 7d. 80/20 Analysis — which products drive 80% of revenue?
WITH prod_rev AS (
    SELECT
        product,
        SUM(revenue) AS revenue,
        SUM(SUM(revenue)) OVER ()   AS total_revenue
    FROM sales
    GROUP BY product
    ORDER BY revenue DESC
),
cumulative AS (
    SELECT
        product,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC)  AS cumulative_revenue,
        total_revenue
    FROM prod_rev
)
SELECT
    product,
    ROUND(revenue, 0)                                          AS revenue,
    ROUND(cumulative_revenue * 100.0 / total_revenue, 2)       AS cumulative_pct
FROM cumulative;
