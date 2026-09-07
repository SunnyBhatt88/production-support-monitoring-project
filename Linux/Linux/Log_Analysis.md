# Linux Log Analysis

## Overview

Log analysis is an important activity in Application Support and Production Support. Application and system logs provide valuable information about errors, warnings, failed transactions, performance issues, and service interruptions.

This document covers common Linux commands and practical approaches used to analyze application logs during incident investigation.

> **Note:** This is a portfolio/practice document demonstrating production support troubleshooting knowledge.

---

## 1. Locate Application Logs

Common Linux log directories include:

```text
/var/log/
```

List available log files:

```bash
ls -lh /var/log/
```

For an application-specific directory:

```bash
ls -lh /path/to/application/logs/
```

---

## 2. View the Beginning of a Log File

Use `head` to view the first few lines:

```bash
head -n 50 application.log
```

This is useful for checking:

* Log format
* Application startup information
* Initial configuration messages
* Timestamp format

---

## 3. View the End of a Log File

Use `tail` to view recent log entries:

```bash
tail -n 100 application.log
```

This is commonly used during incident investigation because recent errors are usually near the end of the active log file.

---

## 4. Monitor Logs in Real Time

Use:

```bash
tail -f application.log
```

This displays new log entries as they are written.

It is useful when reproducing or monitoring an issue in real time.

Press:

```text
Ctrl + C
```

to stop monitoring.

---

## 5. Search for Errors

Use `grep` to search for error messages:

```bash
grep -i "error" application.log
```

The `-i` option makes the search case-insensitive.

For example, it can find:

```text
ERROR
Error
error
```

---

## 6. Search for Exceptions

```bash
grep -i "exception" application.log
```

This is useful for Java and other applications where exceptions are recorded in logs.

You can also search for multiple keywords:

```bash
grep -Ei "error|exception|failed|failure" application.log
```

---

## 7. Search for Warnings

```bash
grep -i "warning" application.log
```

Warnings may provide early indicators of an issue before it becomes a production incident.

---

## 8. Search by Order or Transaction ID

Searching for a unique transaction identifier is one of the most useful troubleshooting techniques.

Example:

```bash
grep "10001" application.log
```

If the application uses an order ID:

```bash
grep "ORDER-10001" application.log
```

This can help trace a transaction through different application processing stages.

---

## 9. Search by API Request ID

If the application generates a request or correlation ID:

```bash
grep "REQ-123456" application.log
```

A correlation ID can help track the same request across multiple services.

---

## 10. Search Multiple Log Files

To search all `.log` files in the current directory:

```bash
grep -i "error" *.log
```

To search recursively inside a directory:

```bash
grep -Rni "error" /path/to/application/logs/
```

Options:

* `-R` = recursive search
* `-n` = display line number
* `-i` = case-insensitive search

---

## 11. Display Context Around an Error

Sometimes the lines before and after an error are important.

Show 5 lines before and after the matching line:

```bash
grep -i -C 5 "error" application.log
```

Show 5 lines before:

```bash
grep -i -B 5 "error" application.log
```

Show 5 lines after:

```bash
grep -i -A 5 "error" application.log
```

---

## 12. Count Errors

To count the number of error entries:

```bash
grep -ic "error" application.log
```

This can help determine whether an error is isolated or occurring repeatedly.

---

## 13. Check Logs for a Specific Time Period

If timestamps are present in the logs, search using the relevant date or time.

Example:

```bash
grep "2026-09-07" application.log
```

For a specific hour:

```bash
grep "10:30" application.log
```

This is useful when an incident has a known start time.

---

## 14. Combine Commands for Better Analysis

For example:

```bash
grep -i "error" application.log | tail -n 20
```

This displays the latest 20 error entries.

Another example:

```bash
grep -i "failed" application.log | wc -l
```

This counts entries containing the word `failed`.

---

## 15. Sort and Analyze Repeated Errors

Extract error messages for further analysis:

```bash
grep -i "error" application.log | sort | uniq -c | sort -nr
```

This can help identify frequently occurring error patterns.

> Log formats vary between applications, so the exact command may need to be adjusted according to the log structure.

---

## 16. Check Application Startup and Shutdown Logs

Search for startup messages:

```bash
grep -i "started" application.log
```

Search for shutdown messages:

```bash
grep -Ei "stopped|shutdown|terminated" application.log
```

This can help determine whether an application service restarted around the time of an incident.

---

## 17. Check Service Logs

For systems using `systemd`, service logs can be reviewed using:

```bash
journalctl -u <service_name>
```

View logs from the last 30 minutes:

```bash
journalctl -u <service_name> --since "30 minutes ago"
```

View recent entries:

```bash
journalctl -u <service_name> -n 100
```

Follow service logs in real time:

```bash
journalctl -u <service_name> -f
```

---

## 18. Check for Disk-Related Log Problems

Logs can consume significant disk space.

Check filesystem usage:

```bash
df -h
```

Check the size of log files:

```bash
du -sh /var/log/*
```

Find large log files:

```bash
find /var/log -type f -size +500M -ls
```

Large log files can contribute to disk-space incidents.

> Do not manually delete production logs unless the organization's approved retention and cleanup procedure allows it.

---

## 19. Log Rotation

Production applications commonly use log rotation to prevent log files from growing indefinitely.

Check for rotated logs:

```bash
ls -lh /var/log/
```

Typical rotated files may look like:

```text
application.log
application.log.1
application.log.2
application.log.gz
```

The exact log rotation configuration depends on the operating system and application.

---

## 20. Sample Production Incident

### Incident

Users report that order transactions are failing.

### Investigation

1. Confirmed the issue through application monitoring.
2. Identified the approximate incident start time.
3. Checked the application log.
4. Searched for `ERROR` and `Exception`.
5. Searched for the affected Order ID.
6. Checked the API request/correlation ID.
7. Reviewed related application-service logs.
8. Compared timestamps between application and dependency logs.
9. Identified repeated database connection errors.
10. Escalated or resolved the issue according to the approved support procedure.

### Example Investigation Commands

```bash
tail -n 100 application.log
```

```bash
grep -Ei "error|exception|failed" application.log
```

```bash
grep "ORDER-10001" application.log
```

```bash
grep "REQ-123456" application.log
```

### Finding

The application logs showed repeated database connectivity errors around the same time that users reported transaction failures.

### Validation

After the issue was addressed:

* New transactions were processed successfully.
* Application errors reduced to normal levels.
* Database connectivity was restored.
* The affected Order ID was validated.
* Application logs were monitored for recurrence.

---

## 21. Practical Log Analysis Workflow

```text
Incident Reported
       |
       v
Identify Application / Service
       |
       v
Identify Incident Start Time
       |
       v
Check Recent Logs
       |
       v
Search ERROR / EXCEPTION / FAILED
       |
       v
Search Order ID / Transaction ID
       |
       v
Search Request / Correlation ID
       |
       v
Compare Related Service Logs
       |
       v
Identify Error Pattern
       |
       v
Determine Suspected Root Cause
       |
       v
Apply Approved Resolution
       |
       v
Validate Application
       |
       v
Monitor Logs
       |
       v
Document RCA
```

---

## 22. Production Support Best Practices

* Always note the incident start time before analyzing logs.
* Search logs using unique transaction or correlation IDs whenever possible.
* Check timestamps carefully.
* Compare application logs with dependent service logs.
* Look for repeated error patterns rather than isolated messages.
* Preserve relevant evidence for RCA.
* Do not modify or delete production logs without authorization.
* Avoid restarting services without understanding the impact and following the approved process.
* Use monitoring tools along with log analysis.
* Document findings, actions, and validation results.
* Escalate when the issue requires another technical team's involvement.

---

## Skills Demonstrated

* Linux / Unix
* Application Log Analysis
* Error and Exception Troubleshooting
* `grep`, `tail`, `head`, `find`, `sort`, `uniq`
* Service Log Analysis
* Transaction / Order ID Tracking
* Correlation ID Analysis
* Incident Investigation
* Production Support
* Root Cause Analysis
* Application Monitoring
* Troubleshooting and Escalation

---

## Author

**Sunny Bhatt**

Application Support | Production Support | Linux | SQL | API Integration | AWS | Git/GitHub
