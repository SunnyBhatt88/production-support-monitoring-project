# API Troubleshooting

## Overview

API troubleshooting is a key activity in Application Support and Production Support. APIs connect applications, databases, e-commerce platforms, payment systems, logistics systems, and external services.

This document provides a practical troubleshooting approach for common REST API issues, including HTTP errors, authentication failures, timeouts, payload problems, dependency failures, and application errors.

> **Note:** This is a portfolio/practice document demonstrating API troubleshooting and production support knowledge.

---

## 1. API Troubleshooting Approach

When an API issue is reported, follow a structured approach:

```text
Issue Reported
      |
      v
Identify API Endpoint
      |
      v
Check HTTP Status Code
      |
      v
Validate Request
      |
      v
Validate Authentication
      |
      v
Check Response / Error Message
      |
      v
Check Application Logs
      |
      v
Check Database / Dependencies
      |
      v
Identify Root Cause
      |
      v
Apply Approved Resolution
      |
      v
Retest API
      |
      v
Validate Business Transaction
      |
      v
Document RCA
```

---

## 2. Collect Initial Information

Before starting investigation, collect:

* API endpoint
* HTTP method
* Request timestamp
* HTTP status code
* Request payload
* Response body
* Response time
* Order/Transaction ID
* Correlation/Request ID
* Environment
* Frequency of the issue
* Number of affected transactions
* Recent application or infrastructure changes

Example:

```text
Environment: Production
API: Order Creation API
Method: POST
Order ID: ORDER-10001
HTTP Status: 500
Time: 10:35 AM
Correlation ID: REQ-789012
```

---

## 3. Check API Availability

Test the endpoint using `curl`:

```bash
curl -i https://api.example.com/health
```

Check:

* HTTP status
* Response body
* Response headers
* Network connectivity

A healthy endpoint may return:

```text
HTTP/1.1 200 OK
```

---

## 4. Check HTTP Status Code

The HTTP status code provides the first indication of the problem.

| Code | Category     | Typical Cause               |
| ---- | ------------ | --------------------------- |
| 200  | Success      | Request processed           |
| 201  | Success      | Resource created            |
| 400  | Client Error | Invalid request             |
| 401  | Client Error | Authentication failure      |
| 403  | Client Error | Permission/access issue     |
| 404  | Client Error | Resource/endpoint not found |
| 408  | Client Error | Request timeout             |
| 409  | Client Error | Data/resource conflict      |
| 429  | Client Error | Rate limit exceeded         |
| 500  | Server Error | Application failure         |
| 502  | Server Error | Upstream service problem    |
| 503  | Server Error | Service unavailable         |
| 504  | Server Error | Gateway timeout             |

---

## 5. Troubleshoot 400 Bad Request

### Possible causes

* Invalid JSON
* Missing mandatory field
* Incorrect field name
* Incorrect data type
* Invalid parameter
* Incorrect request format

### Investigation

Check the request payload carefully.

Example:

```json
{
  "order_id": "10001",
  "quantity": 1
}
```

Verify:

* Required fields
* Field names
* Data types
* JSON syntax
* Business validation rules

### Resolution

Correct the request payload and retest the API.

---

## 6. Troubleshoot 401 Unauthorized

### Possible causes

* Missing Authorization header
* Invalid token
* Expired token
* Incorrect credentials
* Incorrect authentication method

Example:

```text
Authorization: Bearer <token>
```

### Investigation

1. Check authentication configuration.
2. Verify the Authorization header.
3. Confirm that the token is valid through the approved process.
4. Check whether credentials or authentication configuration recently changed.
5. Retest the request.

> Never store real credentials or API tokens in GitHub.

---

## 7. Troubleshoot 403 Forbidden

### Possible causes

* Insufficient permissions
* Incorrect role
* Access restriction
* IP restriction
* Service account permission issue

### Investigation

1. Identify the calling user or service account.
2. Verify required permissions.
3. Check access policies.
4. Check network restrictions if applicable.
5. Escalate to the appropriate access/security team when required.

---

## 8. Troubleshoot 404 Not Found

### Possible causes

* Incorrect endpoint
* Incorrect resource ID
* Incorrect API version
* Resource does not exist

### Investigation

Check:

```text
Base URL
API path
API version
Resource ID
HTTP method
```

Example:

```text
Incorrect:
GET /api/v1/order/10001

Expected:
GET /api/v1/orders/10001
```

---

## 9. Troubleshoot 409 Conflict

A `409 Conflict` may occur when the request conflicts with the current state of a resource.

Possible causes:

* Duplicate order
* Duplicate transaction
* Resource already exists
* Invalid state transition

### Investigation

Validate the transaction in the database:

```sql
SELECT order_id,
       status,
       created_date
FROM orders
WHERE order_id = '10001';
```

Check whether the transaction already exists or has already been processed.

---

## 10. Troubleshoot 429 Too Many Requests

### Possible causes

* Rate limit exceeded
* High request volume
* Incorrect retry mechanism
* Multiple systems sending repeated requests

### Investigation

Check:

* Request volume
* API rate limits
* Retry configuration
* Application logs
* Monitoring alerts

Follow the API provider's approved throttling and retry procedures.

---

## 11. Troubleshoot 500 Internal Server Error

A `500` generally indicates a server-side problem.

### Possible causes

* Application exception
* Database connectivity issue
* Database query failure
* Configuration issue
* Unexpected application error
* Dependency failure

### Investigation

Start with:

```bash
tail -n 100 application.log
```

Search for errors:

```bash
grep -Ei "error|exception|failed" application.log
```

Search using the transaction ID:

```bash
grep "ORDER-10001" application.log
```

Search using correlation ID:

```bash
grep "REQ-789012" application.log
```

Then validate database connectivity and dependent services.

---

## 12. Troubleshoot 502 Bad Gateway

A `502` can indicate that a gateway or proxy could not obtain a valid response from an upstream service.

### Possible causes

* Upstream service unavailable
* Network connectivity issue
* Gateway/proxy issue
* Incorrect upstream configuration
* Service restart

### Investigation

1. Check API gateway/proxy status.
2. Check upstream service availability.
3. Review gateway and application logs.
4. Test upstream connectivity.
5. Compare timestamps across services.

---

## 13. Troubleshoot 503 Service Unavailable

### Possible causes

* Application service stopped
* Server overload
* Maintenance
* Dependency unavailable
* Resource exhaustion

### Investigation

Check the service:

```bash
systemctl status <service_name>
```

Check server resources:

```bash
uptime
```

```bash
free -m
```

```bash
df -h
```

Check application logs:

```bash
tail -n 100 application.log
```

---

## 14. Troubleshoot 504 Gateway Timeout

A `504` indicates that the gateway did not receive a timely response from the upstream service.

### Possible causes

* Slow database query
* Slow upstream API
* Network latency
* Application processing delay
* Timeout configuration

### Investigation

Check API response time:

```bash
curl -o /dev/null -s -w "HTTP Status: %{http_code}\nResponse Time: %{time_total}s\n" https://api.example.com/health
```

Then investigate:

* Application logs
* Database performance
* Upstream services
* Network connectivity
* Gateway timeout configuration

---

## 15. JSON Payload Troubleshooting

Common JSON issues include:

* Missing comma
* Incorrect quotation marks
* Missing mandatory field
* Incorrect field name
* Incorrect data type
* Unexpected NULL value
* Invalid nested object

Example:

```json
{
  "order_id": "10001",
  "quantity": 2,
  "status": "NEW"
}
```

Validate that the API expects the same field names and data types.

---

## 16. API Response Validation

Do not only check the HTTP status code.

For a successful response, validate:

* HTTP status
* Response body
* Required fields
* Business status
* Transaction ID
* Order ID
* Response time

Example:

```json
{
  "order_id": "10001",
  "status": "COMPLETED",
  "transaction_id": "TXN-123456"
}
```

A `200 OK` response does not always mean the business transaction completed successfully. The response body must also be validated.

---

## 17. Postman Troubleshooting

When using Postman:

### Request

Verify:

* HTTP method
* URL
* Query parameters
* Headers
* Authentication
* Request body

### Response

Verify:

* Status code
* Response time
* Response body
* Response headers
* Error message

### Useful Postman checks

```text
Method: POST
URL: https://api.example.com/orders
Content-Type: application/json
Authorization: Bearer <token>
```

---

## 18. API and Database Validation

When an API processes a transaction, validate the corresponding database record when appropriate.

Example:

```sql
SELECT order_id,
       status,
       created_date
FROM orders
WHERE order_id = '10001';
```

Compare:

```text
API Request
     |
     v
Application
     |
     v
Database
     |
     v
API Response
```

Check whether the API response and database state are consistent.

---

## 19. API and Log Correlation

Use unique identifiers to trace a transaction.

Example:

```text
Order ID       : ORDER-10001
Transaction ID : TXN-123456
Correlation ID : REQ-789012
```

Search application logs:

```bash
grep "ORDER-10001" application.log
```

```bash
grep "TXN-123456" application.log
```

```bash
grep "REQ-789012" application.log
```

This helps identify where the transaction failed.

---

## 20. Sample API Incident

### Incident

Users report that order creation is failing.

### Initial Observation

The Order Creation API returns:

```text
HTTP 500 Internal Server Error
```

### Investigation

1. Reproduced the issue using Postman.
2. Confirmed HTTP 500 response.
3. Verified request payload.
4. Checked request headers and authentication.
5. Captured the Order ID and correlation ID.
6. Checked application logs.
7. Found repeated database connection errors.
8. Validated database connectivity.
9. Checked whether transactions were successfully created.
10. Identified the database connectivity issue as the suspected root cause.

### Example Commands

```bash
grep "ORDER-10001" application.log
```

```bash
grep "REQ-789012" application.log
```

### Database Validation

```sql
SELECT order_id,
       status,
       created_date
FROM orders
WHERE order_id = '10001';
```

### Resolution

The underlying dependency issue was addressed according to the approved support procedure.

### Validation

After resolution:

* API returned the expected HTTP status.
* New orders were processed successfully.
* Database connectivity was restored.
* Application logs showed no new related errors.
* Business transaction was validated successfully.

---

## 21. API Troubleshooting Checklist

Before escalating an API issue, collect:

```text
[ ] API endpoint
[ ] HTTP method
[ ] HTTP status code
[ ] Request timestamp
[ ] Response time
[ ] Request payload
[ ] Response body
[ ] Request/Correlation ID
[ ] Order/Transaction ID
[ ] Authentication details/status
[ ] Application log entries
[ ] Database validation
[ ] Dependency status
[ ] Recent changes
```

---

## 22. Production Support Best Practices

* Reproduce the issue safely whenever possible.
* Always capture the HTTP status code.
* Check logs using transaction or correlation IDs.
* Validate both API response and business transaction status.
* Check database and external dependencies.
* Compare timestamps across systems.
* Do not expose credentials or tokens in tickets or repositories.
* Follow approved change and incident-management procedures.
* Avoid making unauthorized production changes.
* Document investigation steps and findings.
* Validate the solution after resolution.
* Document RCA and preventive actions.

---

## Skills Demonstrated

* REST API Troubleshooting
* HTTP Status Code Analysis
* Postman
* curl
* JSON Troubleshooting
* API Request/Response Validation
* Authentication Troubleshooting
* Application Log Analysis
* SQL Data Validation
* API and Database Correlation
* Incident Management
* Root Cause Analysis
* Production Support
* Application Support

---

## Author

**Sunny Bhatt**

Application Support | Production Support | Linux | SQL | API Integration | AWS | Git/GitHub
