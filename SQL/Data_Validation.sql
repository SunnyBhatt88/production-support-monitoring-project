-- SQL Data Validation
-- Application / Production Support Portfolio
-- Database: Oracle SQL
-----------------------

-- Purpose:
-- This document contains sample SQL queries used for
-- application support and production incident investigation.
-------------------------------------------------------------

-- Note:
-- These are safe SELECT-based examples intended for
-- learning and portfolio demonstration.

---

## -- 1. Validate a Specific Order

SELECT order_id,
status,
created_date
FROM orders
WHERE order_id = '10001';

---

## -- 2. Check Recent Orders

SELECT order_id,
status,
created_date
FROM orders
WHERE created_date >= SYSDATE - 1
ORDER BY created_date DESC;

---

## -- 3. Check Failed Transactions

SELECT order_id,
status,
created_date
FROM orders
WHERE status IN ('FAILED', 'ERROR')
ORDER BY created_date DESC;

---

## -- 4. Check NULL Status Values

SELECT order_id,
status,
created_date
FROM orders
WHERE status IS NULL;

---

## -- 5. Count Records with Missing Status

SELECT COUNT(*) AS missing_status
FROM orders
WHERE status IS NULL;

---

## -- 6. Check Duplicate Order IDs

SELECT order_id,
COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

---

## -- 7. Validate Order Status Distribution

SELECT status,
COUNT(*) AS total_records
FROM orders
GROUP BY status
ORDER BY total_records DESC;

---

## -- 8. Check Orders Created on the Current Date

SELECT order_id,
status,
created_date
FROM orders
WHERE TRUNC(created_date) = TRUNC(SYSDATE)
ORDER BY created_date DESC;

---

## -- 9. Check Orders Created Within the Last Hour

SELECT order_id,
status,
created_date
FROM orders
WHERE created_date >= SYSDATE - (1/24)
ORDER BY created_date DESC;

---

## -- 10. Validate a Specific Transaction

SELECT order_id,
status,
created_date
FROM orders
WHERE order_id = '10001'
AND status = 'COMPLETED';

---

## -- 11. Search Orders by Multiple Statuses

SELECT order_id,
status,
created_date
FROM orders
WHERE status IN ('PENDING', 'PROCESSING', 'FAILED')
ORDER BY created_date DESC;

---

## -- 12. Count Orders by Status

SELECT status,
COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY status;

---

## -- 13. Check for Missing Order IDs

SELECT COUNT(*) AS missing_order_id
FROM orders
WHERE order_id IS NULL;

---

## -- 14. Check for Invalid Status Values

SELECT DISTINCT status
FROM orders
WHERE status NOT IN
('PENDING',
'PROCESSING',
'COMPLETED',
'FAILED',
'CANCELLED');

---

## -- 15. Validate Data for a Specific Time Range

SELECT order_id,
status,
created_date
FROM orders
WHERE created_date BETWEEN
TO_DATE('2026-09-07 09:00:00', 'YYYY-MM-DD HH24:MI:SS')
AND TO_DATE('2026-09-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS')
ORDER BY created_date;

---

## -- 16. Identify Repeated Failed Transactions

SELECT order_id,
COUNT(*) AS failure_count
FROM orders
WHERE status = 'FAILED'
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY failure_count DESC;

---

## -- 17. Basic Data Validation Checklist

-- Check:
-- 1. Order ID is present
-- 2. Order status is valid
-- 3. Created date is populated
-- 4. Duplicate records are investigated
-- 5. Failed transactions are identified
-- 6. Recent transactions are validated
-- 7. Unexpected status values are investigated
-- 8. Data is compared with application/API logs

---

## -- Production Support Safety

## -- These examples intentionally use SELECT statements.

-- UPDATE and DELETE operations should NOT be executed
-- in a production environment without proper authorization,
-- change approval, backup/rollback planning, and validation.
