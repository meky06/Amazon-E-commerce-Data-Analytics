--Created new table with new customer values for predictive analysis

--Divided Dataset into 2017 for training and 2018 for testing

-- TRAINING DATASET
-- Features: January-December 2017
-- Target: Repeat purchase during Jan-June 2018

WITH Recency AS (
    SELECT
        c.customer_unique_id,
        DATEDIFF(
            DAY,
            MAX(o.order_approved_at),
            '2017-12-31'
        ) AS Recency
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_approved_at >= '2017-01-01'
      AND o.order_approved_at < '2018-01-01'
    GROUP BY c.customer_unique_id
),

Frequency AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Frequency
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_approved_at >= '2017-01-01'
      AND o.order_approved_at < '2018-01-01'
    GROUP BY c.customer_unique_id
),

Monetary AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS Total_Spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_approved_at >= '2017-01-01'
      AND o.order_approved_at < '2018-01-01'
    GROUP BY c.customer_unique_id
),

Reviews AS (
    SELECT
        c.customer_unique_id,
        AVG(orev.review_score) AS Average_Review_Score
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_reviews orev
        ON o.order_id = orev.order_id
    WHERE o.order_approved_at >= '2017-01-01'
      AND o.order_approved_at < '2018-01-01'
    GROUP BY c.customer_unique_id
),

LateDelivery AS (
    SELECT
        c.customer_unique_id,

        AVG(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN DATEDIFF(
                    DAY,
                    o.order_estimated_delivery_date,
                    o.order_delivered_customer_date
                )
                ELSE 0
            END
        ) AS Avg_Late_Delivery_Days

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    WHERE o.order_approved_at >= '2017-01-01'
      AND o.order_approved_at < '2018-01-01'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL

    GROUP BY c.customer_unique_id
),

Returned2018 AS (
    SELECT DISTINCT
        c.customer_unique_id

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    WHERE o.order_approved_at >= '2018-01-01'
      AND o.order_approved_at < '2018-07-01'
)

SELECT
    r.customer_unique_id,
    r.Recency,
    f.Frequency,
    m.Total_Spent,
    rv.Average_Review_Score,
    ld.Avg_Late_Delivery_Days,

    CASE
        WHEN ret.customer_unique_id IS NOT NULL THEN 1
        ELSE 0
    END AS Repeat_Purchase

FROM Recency r

LEFT JOIN Frequency f
    ON r.customer_unique_id = f.customer_unique_id

LEFT JOIN Monetary m
    ON r.customer_unique_id = m.customer_unique_id

LEFT JOIN Reviews rv
    ON r.customer_unique_id = rv.customer_unique_id

LEFT JOIN LateDelivery ld
    ON r.customer_unique_id = ld.customer_unique_id

LEFT JOIN Returned2018 ret
    ON r.customer_unique_id = ret.customer_unique_id;


-- TESTING DATASET
-- Features: January-June 2018
-- No Repeat_Purchase target

WITH Recency AS (
    SELECT
        c.customer_unique_id,
        DATEDIFF(
            DAY,
            MAX(o.order_approved_at),
            '2018-07-01'
        ) AS Recency
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_approved_at >= '2018-01-01'
      AND o.order_approved_at < '2018-07-01'
    GROUP BY c.customer_unique_id
),

Frequency AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Frequency
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_approved_at >= '2018-01-01'
      AND o.order_approved_at < '2018-07-01'
    GROUP BY c.customer_unique_id
),

Monetary AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS Total_Spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_payments op
        ON o.order_id = op.order_id
    WHERE o.order_approved_at >= '2018-01-01'
      AND o.order_approved_at < '2018-07-01'
    GROUP BY c.customer_unique_id
),

Reviews AS (
    SELECT
        c.customer_unique_id,
        AVG(orev.review_score) AS Average_Review_Score
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_reviews orev
        ON o.order_id = orev.order_id
    WHERE o.order_approved_at >= '2018-01-01'
      AND o.order_approved_at < '2018-07-01'
    GROUP BY c.customer_unique_id
),

LateDelivery AS (
    SELECT
        c.customer_unique_id,

        AVG(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN DATEDIFF(
                    DAY,
                    o.order_estimated_delivery_date,
                    o.order_delivered_customer_date
                )
                ELSE 0
            END
        ) AS Avg_Late_Delivery_Days

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    WHERE o.order_approved_at >= '2018-01-01'
      AND o.order_approved_at < '2018-07-01'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL

    GROUP BY c.customer_unique_id
)

SELECT
    r.customer_unique_id,
    r.Recency,
    f.Frequency,
    m.Total_Spent,
    rv.Average_Review_Score,
    ld.Avg_Late_Delivery_Days

FROM Recency r

LEFT JOIN Frequency f
    ON r.customer_unique_id = f.customer_unique_id

LEFT JOIN Monetary m
    ON r.customer_unique_id = m.customer_unique_id

LEFT JOIN Reviews rv
    ON r.customer_unique_id = rv.customer_unique_id

LEFT JOIN LateDelivery ld
    ON r.customer_unique_id = ld.customer_unique_id;