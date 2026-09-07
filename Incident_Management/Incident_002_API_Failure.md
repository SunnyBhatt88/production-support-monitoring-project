# Incident 002 – API Failure

## Incident Overview

**Incident ID:** INC-002
**Severity:** High
**Category:** Application / API Integration
**Environment:** Production
**Component:** REST API
**Status:** Resolved

## Issue Description

Users reported that transactions were failing while accessing an application feature that depends on a REST API.

Initial investigation showed that the API was returning an unexpected HTTP error response.

Example:

```text
HTTP Status: 500 Internal Server Error
```

## Business Impact

The API failure resulted in:

* Failed transactions
* Application errors
* Delayed order or transaction processing
* Poor user experience
* Potential downstream integration failures

## Initial Investigation

### Step 1 – Validate API Endpoint

The support team verified:

* API endpoint
* HTTP method
* Request headers
* Authentication
* Request payload
* Environment
* Timestamp of the failure

API request example:

```text
Method: POST
Endpoint: /api/orders
Content-Type: application/json
```

### Step 2 – Test Using Postman

The API was tested using Postman to reproduce the issue.

The following were validated:

* HTTP method
* URL
* Headers
* Authentication
* Request body
* Response status
* Response body
* Response time

Example response:

```text
HTTP/1.1 500 Internal Server Error
```

## Step 3 – Analyze HTTP Response

The HTTP status code indicated a server-side application problem.

Common API status codes considered during troubleshooting:

| Status Code | Meaning               |
| ----------- | --------------------- |
| 200         | Successful request    |
| 201         | Resource created      |
| 400         | Bad Request           |
| 401         | Unauthorized          |
| 403         | Forbidden             |
| 404         | Resource Not Found    |
| 409         | Conflict              |
| 429         | Too Many Requests     |
| 500         | Internal Server Error |
| 502         | Bad Gateway           |
| 503         | Service Unavailable   |
| 504         | Gateway Timeout       |

## Step 4 – Check Application Logs

Application logs were reviewed around the time of the failed API request.

Looked for:

* Exceptions
* Database connection failures
* Timeout errors
* Authentication errors
* Invalid payloads
* Downstream service failures
* Application processing errors

Example:

```text
ERROR: Order processing failed
ERROR: Database connection timeout
```

## Step 5 – SQL Validation

SQL queries were used to validate whether the transaction reached the database.

Example:

```sql
SELECT order_id,
       status,
       created_date
FROM orders
WHERE order_id = '10001';
```

The database information was compared with the API request and application logs.

The investigation checked:

* Whether the transaction was created
* Transaction status
* Duplicate records
* Missing data
* Incorrect status
* Database errors

## Root Cause

**Example Root Cause:**

The API request reached the application, but the application encountered a database connectivity issue while processing the transaction. This resulted in an HTTP 500 response being returned to the client.

> This is a simulated production incident created for learning and portfolio demonstration.

## Resolution

The support team followed the approved production support process.

Actions included:

1. Confirmed the API failure using Postman.
2. Reviewed the API response.
3. Analyzed application logs.
4. Validated the affected transaction using SQL.
5. Identified the database connectivity issue.
6. Coordinated with the relevant database/application team.
7. Performed the approved corrective action.
8. Retested the API.
9. Validated the transaction.
10. Monitored the application after resolution.

## Post-Resolution Validation

After the resolution:

* API returned a successful response.
* Transaction processing was validated.
* Database records were checked.
* Application logs showed no new critical errors.
* API response time returned to the expected range.
* Monitoring continued after the incident.

Example successful response:

```text
HTTP Status: 200 OK
```

## RCA Summary

| Item          | Details                              |
| ------------- | ------------------------------------ |
| Incident      | REST API Failure                     |
| Impact        | Transaction processing failure       |
| Detection     | Application monitoring / user report |
| API Tool      | Postman                              |
| HTTP Error    | 500 Internal Server Error            |
| Investigation | Postman + Logs + SQL                 |
| Root Cause    | Database connectivity issue          |
| Resolution    | Approved corrective action           |
| Validation    | API + Database + Application         |
| Status        | Resolved                             |

## Preventive Actions

Recommended preventive measures:

* Monitor API response codes.
* Monitor API response time.
* Configure appropriate alerts.
* Monitor database connectivity.
* Review recurring API failures.
* Improve application exception handling.
* Maintain API and database dependency documentation.
* Perform regular API health checks.
* Document recurring incidents and resolutions.

## Production Support Skills Demonstrated

* REST API Troubleshooting
* Postman API Testing
* HTTP Status Code Analysis
* JSON Request/Response Validation
* SQL Query Execution
* Database Troubleshooting
* Application Log Analysis
* Incident Management
* Root Cause Analysis
* Production Support
* Post-Incident Validation

## Troubleshooting Flow

```text
API Failure
     ↓
Check HTTP Status
     ↓
Reproduce Using Postman
     ↓
Validate Request / Response
     ↓
Check Application Logs
     ↓
Perform SQL Validation
     ↓
Check Downstream Dependencies
     ↓
Identify Root Cause
     ↓
Apply Approved Resolution
     ↓
Retest API
     ↓
Validate Transaction
     ↓
Monitor & Document RCA
```

## Conclusion

This incident demonstrates a structured approach to troubleshooting REST API failures using Postman, application logs, SQL validation, and production support processes.

The objective is to identify the root cause efficiently, restore application functionality, validate the transaction, and document preventive actions.
