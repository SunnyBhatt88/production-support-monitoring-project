# API Health Check

## Overview

API health checks are an important part of Application Support and Production Support. REST APIs are commonly used to exchange data between applications, e-commerce platforms, databases, payment systems, and external services.

This document provides a practical approach to checking API availability, response status, response time, headers, authentication, payloads, and response data.

> **Note:** This is a portfolio/practice document demonstrating API troubleshooting and production support knowledge.

---

## 1. Basic API Health Check

A basic API health check should verify:

* API endpoint availability
* HTTP response status
* Response time
* Response body
* Required headers
* Authentication
* Request and response format
* Dependency availability

Example endpoint:

```text
GET https://api.example.com/health
```

A healthy API may return:

```text
HTTP 200 OK
```

Example response:

```json
{
  "status": "UP",
  "message": "Application is healthy"
}
```

---

## 2. Common HTTP Status Codes

| Status Code | Meaning               | Support Interpretation                   |
| ----------- | --------------------- | ---------------------------------------- |
| 200         | OK                    | Request successful                       |
| 201         | Created               | Resource created successfully            |
| 202         | Accepted              | Request accepted for processing          |
| 204         | No Content            | Request successful without response body |
| 400         | Bad Request           | Invalid request/payload                  |
| 401         | Unauthorized          | Authentication missing or invalid        |
| 403         | Forbidden             | Access denied                            |
| 404         | Not Found             | Endpoint/resource not found              |
| 408         | Request Timeout       | Request timed out                        |
| 409         | Conflict              | Request conflicts with existing data     |
| 429         | Too Many Requests     | Rate limit exceeded                      |
| 500         | Internal Server Error | Server-side application error            |
| 502         | Bad Gateway           | Upstream service issue                   |
| 503         | Service Unavailable   | Service unavailable                      |
| 504         | Gateway Timeout       | Upstream service timeout                 |

---

## 3. Test API Using curl

A simple GET request:

```bash
curl -i https://api.example.com/health
```

The `-i` option displays response headers along with the response body.

---

## 4. Check API Response Headers

```bash
curl -I https://api.example.com/health
```

Important headers may include:

```text
Content-Type
Authorization
Cache-Control
Content-Length
Date
Server
```

Headers can provide useful information during troubleshooting.

---

## 5. Check API Response Time

Use:

```bash
curl -o /dev/null -s -w "HTTP Status: %{http_code}\nResponse Time: %{time_total}s\n" https://api.example.com/health
```

Example:

```text
HTTP Status: 200
Response Time: 0.245s
```

A sudden increase in response time may indicate:

* Database performance issues
* High server load
* Network latency
* External API dependency issues
* Application processing delays

---

## 6. Test a GET API

Example:

```bash
curl -X GET "https://api.example.com/orders/10001"
```

Expected response:

```json
{
  "order_id": "10001",
  "status": "COMPLETED"
}
```

Validate:

* HTTP status
* Order ID
* Order status
* Required response fields
* Response time

---

## 7. Test a POST API

Example:

```bash
curl -X POST "https://api.example.com/orders" \
-H "Content-Type: application/json" \
-d '{
  "order_id": "10001",
  "product_id": "P100",
  "quantity": 1
}'
```

Validate:

* HTTP status
* Request payload
* Response body
* Required fields
* Transaction ID
* Error message, if any

---

## 8. API Headers

Common request headers include:

```text
Content-Type: application/json
Accept: application/json
Authorization: Bearer <token>
```

Example:

```bash
curl -X GET "https://api.example.com/orders/10001" \
-H "Accept: application/json" \
-H "Authorization: Bearer <token>"
```

> Never commit real API keys, passwords, tokens, or other credentials to a GitHub repository.

---

## 9. JSON Response Validation

Example response:

```json
{
  "order_id": "10001",
  "status": "COMPLETED",
  "amount": 1500,
  "currency": "INR"
}
```

Validate:

* JSON is correctly formatted
* Required fields are present
* Values have the expected format
* Status is correct
* No unexpected NULL values are returned

For example, verify that:

```text
order_id
status
amount
currency
```

are available in the response.

---

## 10. API Testing Using Postman

Postman can be used to test REST APIs during application support activities.

### Basic steps

1. Open Postman.
2. Select the HTTP method.
3. Enter the API endpoint.
4. Add required headers.
5. Configure authentication.
6. Add the request body if required.
7. Send the request.
8. Check HTTP status.
9. Validate response body.
10. Check response time.
11. Record the result.

Example:

```text
Method: GET

Endpoint:
https://api.example.com/orders/10001

Expected Status:
200 OK
```

---

## 11. API Troubleshooting by HTTP Status

### 400 Bad Request

Possible causes:

* Invalid JSON
* Missing required field
* Incorrect data format
* Invalid parameter

Actions:

1. Validate request payload.
2. Check mandatory fields.
3. Check data types.
4. Compare with API documentation.
5. Retest the request.

---

### 401 Unauthorized

Possible causes:

* Missing authentication
* Expired token
* Invalid credentials
* Incorrect Authorization header

Actions:

1. Verify authentication method.
2. Check token validity.
3. Check Authorization header.
4. Retest with valid credentials through the approved process.

---

### 403 Forbidden

Possible causes:

* Insufficient permissions
* Incorrect role
* Access restriction
* IP/network restriction

Actions:

1. Verify the user/service account.
2. Check required permissions.
3. Check access restrictions.
4. Escalate to the appropriate team if required.

---

### 404 Not Found

Possible causes:

* Incorrect endpoint
* Incorrect resource ID
* Resource does not exist
* Wrong API version

Actions:

1. Verify endpoint.
2. Verify resource ID.
3. Check API version.
4. Validate the resource in the database if applicable.

---

### 429 Too Many Requests

Possible causes:

* API rate limit exceeded
* Excessive requests
* Retry mechanism generating repeated requests

Actions:

1. Check request volume.
2. Review API rate-limit configuration.
3. Check retry behavior.
4. Follow the service's approved throttling/retry approach.

---

### 500 Internal Server Error

Possible causes:

* Application exception
* Database issue
* Configuration problem
* Unexpected application failure

Actions:

1. Check API response.
2. Check application logs.
3. Search using transaction/correlation ID.
4. Validate database connectivity.
5. Check dependent services.
6. Identify the root cause.

---

### 502 Bad Gateway

Possible causes:

* Upstream service unavailable
* Gateway/proxy issue
* Network problem
* Incorrect upstream configuration

Actions:

1. Check gateway response.
2. Check upstream service availability.
3. Review application/gateway logs.
4. Test upstream connectivity.

---

### 503 Service Unavailable

Possible causes:

* Application service stopped
* Server overload
* Maintenance
* Dependency unavailable

Actions:

1. Check service status.
2. Check server health.
3. Check application logs.
4. Check monitoring alerts.
5. Validate dependent services.

---

### 504 Gateway Timeout

Possible causes:

* Slow upstream service
* Database query delay
* Network latency
* Application processing timeout

Actions:

1. Check response time.
2. Review application logs.
3. Check database performance.
4. Check upstream services.
5. Compare application and gateway timestamps.

---

## 12. API and Application Log Correlation

During an API incident, use a unique identifier whenever possible.

Examples:

```text
Order ID: ORDER-10001
Transaction ID: TXN-123456
Correlation ID: REQ-789012
```

Search the application log:

```bash
grep "ORDER-10001" application.log
```

Or:

```bash
grep "REQ-789012" application.log
```

This helps correlate:

```text
API Request
     |
     v
Application Processing
     |
     v
Database / External Service
     |
     v
API Response
```

---

## 13. API Health Check Flow

```text
API Issue Reported
       |
       v
Check Endpoint Availability
       |
       v
Check HTTP Status
       |
       v
Check Response Time
       |
       v
Validate Headers
       |
       v
Validate Authentication
       |
       v
Validate Request Payload
       |
       v
Validate JSON Response
       |
       v
Check Application Logs
       |
       v
Check Database / Dependency
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
```

---

## 14. Sample Production Incident

### Incident

Users report that order transactions are failing through the API.

### Initial Observation

API requests are returning:

```text
HTTP 500 Internal Server Error
```

### Investigation

1. Reproduced the API request using Postman.
2. Confirmed the HTTP 500 response.
3. Verified request headers and payload.
4. Checked application logs.
5. Searched logs using the Order ID.
6. Checked the correlation/request ID.
7. Reviewed database connectivity.
8. Checked dependent services.
9. Identified the suspected database connectivity problem.

### Example Commands

```bash
curl -i https://api.example.com/orders/10001
```

```bash
grep "10001" application.log
```

```bash
grep "REQ-789012" application.log
```

### Resolution

The underlying dependency issue was addressed according to the approved support procedure.

### Validation

After resolution:

* API returned HTTP 200 for successful requests.
* Order transaction was processed successfully.
* Database connectivity was confirmed.
* Application logs showed no new related errors.
* API response time returned to the expected range.

---

## 15. API Support Checklist

Before escalating an API issue, collect:

* API endpoint
* HTTP method
* HTTP status code
* Request timestamp
* Response time
* Request/correlation ID
* Transaction/Order ID
* Request payload
* Response body
* Relevant headers
* Application log entries
* Database validation results
* Dependency status

This information helps reduce investigation and resolution time.

---

## Skills Demonstrated

* REST API Troubleshooting
* API Health Checks
* Postman
* curl
* HTTP Status Codes
* JSON Validation
* API Request/Response Analysis
* Authentication Troubleshooting
* Application Log Analysis
* Transaction/Order Tracking
* API and Database Validation
* Incident Management
* Production Support
* Root Cause Analysis

---

## Author

**Sunny Bhatt**

Application Support | Production Support | Linux | SQL | API Integration | AWS | Git/GitHub
