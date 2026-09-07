# AWS CloudWatch Monitoring

## Overview

Amazon CloudWatch is an AWS monitoring and observability service used to collect metrics, monitor resources, create alarms, and help identify application and infrastructure issues.

This document demonstrates a practical CloudWatch monitoring approach from an Application Support / Production Support perspective.

The focus is on:

* EC2 monitoring
* CloudWatch metrics
* CloudWatch alarms
* CPU monitoring
* Network monitoring
* Application health monitoring
* Log monitoring
* Incident detection
* Troubleshooting
* Production support workflow

> **Portfolio Note:** This document represents hands-on learning and portfolio practice completed as part of AWS training. The examples demonstrate monitoring and troubleshooting methodology and should not be interpreted as professional production AWS experience.

---

# 1. What is Amazon CloudWatch?

CloudWatch provides monitoring and observability capabilities for AWS resources and applications.

It can help support teams:

* Monitor infrastructure
* Track resource utilization
* Detect abnormal behavior
* Create alerts
* Investigate incidents
* Review logs
* Identify performance trends
* Support incident troubleshooting

For an Application Support Engineer, CloudWatch can provide useful information before and during an application incident.

---

# 2. CloudWatch Monitoring Architecture

A basic monitoring flow can be represented as:

```text
AWS Resource
     |
     v
CloudWatch Metrics / Logs
     |
     v
Monitoring
     |
     v
CloudWatch Alarm
     |
     v
Alert / Notification
     |
     v
Support Team
     |
     v
Investigation
     |
     v
Resolution / RCA
```

Example:

```text
EC2 CPU Utilization
        |
        v
CloudWatch Metric
        |
        v
CPU > Threshold
        |
        v
CloudWatch Alarm
        |
        v
Support Engineer
        |
        v
Linux + Application Investigation
```

---

# 3. Important CloudWatch Concepts

| Concept    | Purpose                                            |
| ---------- | -------------------------------------------------- |
| Metric     | Numerical measurement collected over time          |
| Namespace  | Container/category for related metrics             |
| Dimension  | Identifies a specific resource or metric attribute |
| Alarm      | Monitors a metric against a defined condition      |
| Log Group  | Collection of related log streams                  |
| Log Stream | Sequence of log events from a source               |
| Dashboard  | Visual display of metrics                          |
| Event      | Activity or state change that can be monitored     |

---

# 4. EC2 Metrics

CloudWatch can be used to monitor EC2 resources.

Important EC2 metrics include:

| Metric                     | Purpose                            |
| -------------------------- | ---------------------------------- |
| CPUUtilization             | Measures CPU usage                 |
| NetworkIn                  | Incoming network traffic           |
| NetworkOut                 | Outgoing network traffic           |
| DiskReadOps                | Number of disk read operations     |
| DiskWriteOps               | Number of disk write operations    |
| StatusCheckFailed          | Indicates failed EC2 status checks |
| StatusCheckFailed_Instance | Instance-level status check        |
| StatusCheckFailed_System   | System-level status check          |

These metrics can help identify infrastructure-related problems.

---

# 5. CPU Utilization Monitoring

CPU utilization is one of the most useful metrics for application and production support.

High CPU can result in:

* Slow application response
* API timeouts
* Transaction delays
* Increased processing time
* Application instability

### Investigation Process

1. Open CloudWatch.
2. Select the relevant EC2 metric.
3. Review CPUUtilization.
4. Identify when CPU increased.
5. Check whether the increase is temporary or sustained.
6. Correlate the time with application incidents.
7. If server access is available, investigate Linux processes.

Linux command:

```bash id="1w7g6e"
top
```

Additional check:

```bash id="1a0c99"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
```

---

# 6. Network Monitoring

Network metrics can help identify unusual traffic patterns or connectivity-related problems.

Important metrics:

* NetworkIn
* NetworkOut

### Investigation Approach

1. Review NetworkIn.
2. Review NetworkOut.
3. Compare current traffic with normal behavior.
4. Check whether traffic changes correlate with the incident.
5. Verify application connectivity.
6. Review security and network configuration where applicable.

Linux connectivity checks:

```bash id="t2icf4"
ss -tulnp
```

```bash id="n7q9ij"
curl -I https://<hostname>
```

---

# 7. Status Check Monitoring

EC2 status checks can be monitored through CloudWatch.

The key metric is:

```text
StatusCheckFailed
```

A failed status check may indicate:

* Infrastructure problems
* Instance-level problems
* Operating system issues
* Network problems

### Troubleshooting Flow

```text
Status Check Failed
        |
        v
Check EC2 Instance State
        |
        v
Identify System vs Instance Check
        |
        v
Review Recent EC2 Events
        |
        v
Review CloudWatch Metrics
        |
        v
Check OS/Application if Accessible
        |
        v
Follow Approved Recovery Procedure
```

---

# 8. CloudWatch Alarms

A CloudWatch alarm monitors a metric and evaluates it against a configured condition.

For example:

```text
Metric: CPUUtilization
Condition: Greater than 80%
Period: 5 minutes
Evaluation: Configured number of periods
Action: Notification / operational response
```

An alarm can help identify an issue before users report it.

### Example

```text
CPU Utilization
      |
      v
Above Defined Threshold
      |
      v
CloudWatch Alarm
      |
      v
Alert Generated
      |
      v
Support Investigation
```

---

# 9. Alarm States

A CloudWatch alarm can have different states.

### OK

The monitored metric is within the defined condition.

### ALARM

The metric has crossed the configured threshold according to the alarm evaluation settings.

### INSUFFICIENT_DATA

CloudWatch does not have enough data to determine the alarm state.

When an alarm changes state, the support team should investigate the reason rather than immediately assuming that the application is down.

---

# 10. Example CPU Alarm

### Monitoring Requirement

Alert the support team when EC2 CPU utilization remains high.

### Example Configuration

```text
Metric:
CPUUtilization

Threshold:
Greater than 80%

Evaluation:
Multiple consecutive evaluation periods

Purpose:
Detect sustained high CPU utilization
```

### Investigation After Alert

1. Confirm the alarm state.
2. Identify the affected EC2 instance.
3. Review the CPU graph.
4. Identify the start time.
5. Check application activity during the same period.
6. Connect to the server if permitted.
7. Run:

```bash id="v7xqym"
top
```

8. Identify high-CPU processes.
9. Review application logs.
10. Determine whether the condition is expected or abnormal.

---

# 11. CloudWatch Dashboards

CloudWatch dashboards can provide a centralized view of important monitoring metrics.

A support dashboard could include:

```text
EC2 Instance Health
        |
        +-- CPU Utilization
        |
        +-- Network In
        |
        +-- Network Out
        |
        +-- Status Check
        |
        +-- Application Metrics
        |
        +-- Error/Failure Metrics
```

### Benefits

* Faster incident detection
* Centralized monitoring
* Easier trend analysis
* Better visibility during incidents
* Improved operational awareness

---

# 12. Monitoring Trends

A single metric value does not always indicate a problem.

For example:

```text
CPU = 85%
```

may be normal during a scheduled batch job.

However:

```text
CPU = 85%
CPU = 90%
CPU = 95%
CPU = 98%
```

over a sustained period may indicate a problem.

Therefore, support engineers should review:

* Current value
* Historical trend
* Duration
* Time of occurrence
* Related application activity
* Business impact

---

# 13. CloudWatch Logs

CloudWatch can also be used for centralized log monitoring when application or system logs are configured for collection.

Logs can help investigate:

* Application errors
* Exceptions
* Authentication failures
* API failures
* Transaction failures
* Service failures

Typical troubleshooting approach:

```text
Alert
 |
 v
Identify Time
 |
 v
Search Logs
 |
 v
Find Error / Exception
 |
 v
Correlate Transaction ID
 |
 v
Check API / Database
 |
 v
Identify Root Cause
```

---

# 14. Log Investigation

When investigating an application incident:

### Step 1 – Identify the incident time

Example:

```text
Incident reported: 10:30 AM
```

### Step 2 – Review logs around the same time

Look for:

* ERROR
* Exception
* Failed
* Timeout
* Connection
* Authentication

### Step 3 – Correlate identifiers

Useful identifiers include:

* Order ID
* Transaction ID
* Request ID
* Correlation ID

### Step 4 – Correlate with infrastructure metrics

Compare logs with:

* CPU
* Network
* Status checks
* Application metrics

This helps establish a timeline.

---

# 15. Application Monitoring

CloudWatch monitoring should not be limited to infrastructure.

From an Application Support perspective, monitoring should also consider:

* Application availability
* API response
* Error rate
* Transaction failures
* Response time
* Service health
* Database connectivity

Example:

```text
User Reports Transaction Failure
              |
              v
Check Application/API
              |
              v
Check CloudWatch Metrics
              |
              v
Check Application Logs
              |
              v
Check Database
              |
              v
Identify Root Cause
```

---

# 16. Incident Scenario – High CPU Alert

## Incident ID

`CW-INC-001`

## Severity

High

## Environment

Production simulation / portfolio practice

## Symptoms

Users report that the application is responding slowly.

## Monitoring Alert

CloudWatch CPUUtilization crosses the configured threshold.

## Investigation

1. Reviewed the CloudWatch alarm.
2. Identified the affected EC2 instance.
3. Reviewed CPU utilization over the incident period.
4. Confirmed sustained high CPU usage.
5. Connected to the Linux instance where access was available.
6. Executed:

```bash id="ujcqtd"
top
```

7. Identified a resource-intensive process.
8. Reviewed application logs.
9. Correlated the event with the application slowdown.

## Root Cause

A resource-intensive application process caused sustained CPU utilization.

## Resolution

The process was investigated and the appropriate corrective action was performed according to the approved operational procedure.

## Validation

After corrective action:

* CPU utilization returned to an acceptable level.
* Application response improved.
* Application endpoint responded successfully.
* No new related errors were observed.

## Preventive Actions

* Review CPU thresholds.
* Monitor recurring high-CPU processes.
* Review application resource utilization.
* Maintain appropriate CloudWatch alarms.
* Document the incident and RCA.

---

# 17. Incident Scenario – API Failure

## Problem

Users report failed transactions.

### Monitoring

CloudWatch shows an increase in application/API errors during the incident period.

### Investigation

1. Identify the incident start time.
2. Review CloudWatch metrics.
3. Review application logs.
4. Identify failed API requests.
5. Capture transaction or correlation IDs.
6. Check API response status.
7. Validate database records.
8. Determine whether the failure is application, API, or database related.

### Example API Status

```text
HTTP 500 – Internal Server Error
```

### Possible Root Cause

A backend dependency such as a database or internal service may be unavailable or experiencing failures.

### Validation

After resolution:

* API returns expected HTTP status.
* Transactions process successfully.
* Error rate returns to normal.
* CloudWatch metrics stabilize.
* No new related application errors are observed.

---

# 18. CloudWatch Troubleshooting Workflow

```text
Incident / Alert
       |
       v
Identify Affected Resource
       |
       v
Check CloudWatch Alarm
       |
       v
Review Metric Timeline
       |
       v
Check EC2 / Application Health
       |
       v
Review Logs
       |
       v
Correlate Transaction / Request ID
       |
       v
Check API / Database / Dependencies
       |
       v
Identify Root Cause
       |
       v
Apply Approved Resolution
       |
       v
Validate Application
       |
       v
Document RCA
       |
       v
Define Preventive Actions
```

---

# 19. CloudWatch Monitoring Checklist

### Infrastructure

* [ ] EC2 instance state checked
* [ ] EC2 status checks reviewed
* [ ] CPU utilization reviewed
* [ ] Network metrics reviewed
* [ ] Disk activity reviewed

### Application

* [ ] Application availability checked
* [ ] API health checked
* [ ] Error rate reviewed
* [ ] Application logs reviewed
* [ ] Transaction/correlation ID identified

### Alarm

* [ ] Alarm state confirmed
* [ ] Alarm start time identified
* [ ] Threshold reviewed
* [ ] Metric trend analyzed
* [ ] False positive considered

### Incident

* [ ] Business impact identified
* [ ] Timeline documented
* [ ] Root cause identified
* [ ] Resolution documented
* [ ] Post-resolution validation completed
* [ ] Preventive action identified

---

# 20. Monitoring Best Practices

1. Monitor both infrastructure and application health.
2. Use meaningful thresholds instead of excessive alerts.
3. Review trends instead of relying on a single metric value.
4. Correlate CloudWatch metrics with application logs.
5. Use incident timestamps to narrow investigations.
6. Use transaction and correlation IDs whenever available.
7. Avoid unnecessary alert noise.
8. Document recurring incidents.
9. Review monitoring gaps after major incidents.
10. Never store credentials, access keys, tokens, passwords, or other secrets in GitHub.

---

# 21. Production Support Perspective

CloudWatch can support several stages of the incident lifecycle:

| Incident Stage | CloudWatch Usage                |
| -------------- | ------------------------------- |
| Detection      | Identify abnormal metrics       |
| Investigation  | Analyze metric trends           |
| Correlation    | Compare metrics with logs       |
| Resolution     | Confirm infrastructure recovery |
| Validation     | Verify metrics return to normal |
| Prevention     | Improve alarms and monitoring   |

This helps Application Support teams move from reactive troubleshooting toward proactive monitoring.

---

# 22. Skills Demonstrated

This portfolio exercise demonstrates practical understanding of:

* Amazon CloudWatch
* EC2 monitoring
* CloudWatch metrics
* CloudWatch alarms
* CPU monitoring
* Network monitoring
* Infrastructure monitoring
* Log monitoring concepts
* Application monitoring
* Incident investigation
* Incident Management
* Root Cause Analysis
* Linux troubleshooting
* API troubleshooting
* Production Support methodology
* Monitoring and alerting concepts
* Technical documentation
* Git/GitHub

---

## Author

**Sunny Bhatt**

Application Support / Production Support

GitHub Portfolio Project – AWS & Production Support Practice
