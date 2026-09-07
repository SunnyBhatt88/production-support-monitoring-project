-- SQL Incident Investigation Queries
-- Application / Production Support Portfolio
-- Database: Oracle SQL
-----------------------

-- Purpose:
-- Sample SQL queries used during production incident
-- investigation and application support troubleshooting.
---------------------------------------------------------

-- Note:
-- These are SELECT-based examples intended for learning
-- and portfolio demonstration.

---

## -- 1. Identify Recently Failed Orders

SELECT order_id,
status,
created_date
FROM orders
WHERE status = 'FAILED'
AND created_date >= SYSDATE - 1
ORDER BY created_date DESC;

---

## -- 2. Identify Orders Stuck in Pending Status

SELECT order_id,
status,
created_date
FROM orders
WHERE status = 'PENDING'
AND created_date < SYSDATE - (2/24)
ORDER BY created_date;

---

## -- 3. Identify Orders Stuck in Processing Status

SELECT order_id,
status,
created_date
FROM orders
WHERE status = 'PROCESSING'
AND created_date < SYSDATE - (1/24)
ORDER BY created_date;

---

## -- 4. Find Duplicate Orders

SELECT order_id,
COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

---

## -- 5. Find Multiple Failed Attempts for an Order

SELECT order_id,
COUNT(*) AS failure_count
FROM orders
WHERE status = 'FAILED'
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY failure_count DESC;

---

## -- 6. Check a Specific Order During an Incident

SELECT order_id,
status,
created_date
FROM orders
WHERE order_id = '10001';

---

## -- 7. Check Orders Processed During an Incident Window

SELECT order_id,
status,
created_date
FROM orders
WHERE created_date BETWEEN
TO_DATE('2026-09-07 09:00:00', 'YYYY-MM-DD HH24:MI:SS')
AND TO_DATE('2026-09-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS')
ORDER BY created_date;

---

## -- 8. Count Transactions by Status

SELECT status,
COUNT(*) AS transaction_count
FROM orders
GROUP BY status
ORDER BY transaction_count DESC;

---

## -- 9. Check Failure Rate by Status

SELECT
COUNT(*) AS total_orders,
SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END)
AS failed_orders
FROM orders;

---

## -- 10. Identify Missing or NULL Status

SELECT order_id,
status,
created_date
FROM orders
WHERE status IS NULL
ORDER BY created_date DESC;

---

## -- 11. Identify Missing Order IDs

SELECT COUNT(*) AS missing_order_id
FROM orders
WHERE order_id IS NULL;

---

## -- 12. Identify Unexpected Status Values

SELECT DISTINCT status
FROM orders
WHERE status NOT IN
('PENDING',
'PROCESSING',
'COMPLETED',
'FAILED',
'CANCELLED');

---

## -- 13. Check Recent Transaction Volume

SELECT COUNT(*) AS transaction_count
FROM orders
WHERE created_date >= SYSDATE - (1/24);

---

## -- 14. Transaction Volume by Hour

SELECT TO_CHAR(created_date, 'YYYY-MM-DD HH24') AS transaction_hour,
COUNT(*) AS transaction_count
FROM orders
WHERE created_date >= SYSDATE - 1
GROUP BY TO_CHAR(created_date, 'YYYY-MM-DD HH24')
ORDER BY transaction_hour;

---

## -- 15. Failed Transactions by Hour

SELECT TO_CHAR(created_date, 'YYYY-MM-DD HH24') AS failure_hour,
COUNT(*) AS failure_count
FROM orders
WHERE status = 'FAILED'
AND created_date >= SYSDATE - 1
GROUP BY TO_CHAR(created_date, 'YYYY-MM-DD HH24')
ORDER BY failure_hour;

---

## -- 16. Find Orders with Recent Processing Issues

SELECT order_id,
status,
created_date
FROM orders
WHERE status IN ('FAILED', 'PENDING', 'PROCESSING')
AND created_date >= SYSDATE - 1
ORDER BY created_date DESC;

---

## -- 17. Compare Successful and Failed Transactions

SELECT
SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END)
AS successful_orders,
SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END)
AS failed_orders,
COUNT(*) AS total_orders
FROM orders
WHERE created_date >= SYSDATE - 1;

---

## -- 18. Find Orders Created on a Specific Date

SELECT order_id,
status,
created_date
FROM orders
WHERE TRUNC(created_date) =
TO_DATE('2026-09-07', 'YYYY-MM-DD')
ORDER BY created_date;

---

## -- 19. Investigate a Specific Failure Pattern

SELECT order_id,
status,
created_date
FROM orders
WHERE status = 'FAILED'
AND created_date >= SYSDATE - 1
ORDER BY created_date DESC;

---

## -- 20. Production Incident Investigation Checklist

## -- During an incident, validate:

-- 1. Is the affected transaction present?
-- 2. What is the current transaction status?
-- 3. Are there duplicate records?
-- 4. Are transactions stuck in PENDING?
-- 5. Are transactions stuck in PROCESSING?
-- 6. Are failure volumes increasing?
-- 7. Are NULL or unexpected values present?
-- 8. Did failures start at a specific time?
-- 9. Is transaction volume unusually high or low?
-- 10. Do database results match application/API logs?

---

## -- Production Support Safety

## -- These examples intentionally use SELECT statements.

-- Do not execute UPDATE or DELETE statements in production
-- without proper authorization, change approval,
-- backup/rollback planning, and validation.
