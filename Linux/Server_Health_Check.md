# Linux Server Health Check

## Overview

This document provides a practical Linux server health-check process for Application Support and Production Support activities.

The objective is to quickly identify CPU, memory, disk, filesystem, process, service, network, and application-log related issues.

> **Note:** This is a portfolio/practice document demonstrating production support troubleshooting knowledge.

---

## 1. Check Server Uptime and Load

### Check system uptime

```bash
uptime
```

Example:

```text
09:30:10 up 25 days, 4:32, 2 users, load average: 0.85, 0.72, 0.65
```

Check:

* Server uptime
* Number of logged-in users
* Load average

### Check logged-in users

```bash
who
```

---

## 2. Check CPU Utilization

### Using top

```bash
top
```

Check:

* Overall CPU utilization
* Load average
* Processes consuming high CPU
* Memory utilization

### Find processes using high CPU

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
```

This helps identify the processes consuming the highest CPU.

---

## 3. Check Memory Utilization

```bash
free -m
```

Important values:

* Total memory
* Used memory
* Available memory
* Swap usage

### Find processes consuming high memory

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
```

---

## 4. Check Disk Space

```bash
df -h
```

Check for filesystems approaching high utilization.

Example:

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   42G    8G  84% /
```

High disk utilization can cause application failures, log-writing problems, and service issues.

### Find large directories

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail
```

This can help identify directories consuming significant disk space.

> Before deleting or moving files in a production environment, follow the organization's approved cleanup and change-management process.

---

## 5. Check Inode Utilization

Sometimes disk space is available but the filesystem can still become unavailable because all inodes are consumed.

```bash
df -i
```

Check the `IUse%` value.

High inode utilization can occur when a system contains a very large number of small files.

---

## 6. Check Mounted Filesystems

```bash
mount
```

For systems using `systemd`, the following command can also be useful:

```bash
findmnt
```

Verify that required filesystems are mounted correctly.

---

## 7. Check Running Processes

### List all processes

```bash
ps -ef
```

### Search for a specific process

```bash
pgrep -af <process_name>
```

Example:

```bash
pgrep -af java
```

This can help verify whether an application process is running.

---

## 8. Check Application Services

On systems using `systemd`:

```bash
systemctl status <service_name>
```

Example:

```bash
systemctl status nginx
```

### Check whether a service is active

```bash
systemctl is-active <service_name>
```

### Check whether a service is enabled

```bash
systemctl is-enabled <service_name>
```

### Review recent service logs

```bash
journalctl -u <service_name> --since "30 minutes ago"
```

> The exact service-management commands can vary depending on the Linux distribution and service configuration.

---

## 9. Check Network Connectivity

### Check listening ports

```bash
ss -tulnp
```

This can help identify services listening on TCP/UDP ports.

### Test hostname connectivity

```bash
ping <hostname>
```

### Test application endpoint connectivity

```bash
curl -I http://<hostname>:<port>
```

For HTTPS:

```bash
curl -I https://<hostname>
```

These checks can help determine whether a server or application endpoint is reachable.

---

## 10. Check DNS Resolution

```bash
nslookup <hostname>
```

If available:

```bash
dig <hostname>
```

DNS issues can result in application connectivity failures even when the server itself is running normally.

---

## 11. Analyze Application Logs

Application logs are one of the most important sources of information during production troubleshooting.

Common log locations include:

```text
/var/log/
```

Example commands:

### View the latest log entries

```bash
tail -n 100 <application.log>
```

### Monitor logs in real time

```bash
tail -f <application.log>
```

### Search for errors

```bash
grep -i "error" <application.log>
```

### Search for exceptions

```bash
grep -i "exception" <application.log>
```

### Search for a specific transaction/order ID

```bash
grep "10001" <application.log>
```

---

## 12. Basic Server Health-Check Flow

A typical Application/Production Support health check can follow this sequence:

```text
User reports issue
       |
       v
Check application availability
       |
       v
Check server uptime and load
       |
       v
Check CPU and memory
       |
       v
Check disk and filesystem
       |
       v
Check application processes
       |
       v
Check application services
       |
       v
Check network connectivity
       |
       v
Analyze application logs
       |
       v
Validate database/API dependencies
       |
       v
Identify root cause
       |
       v
Resolve and validate
       |
       v
Document RCA and preventive action
```

---

## 13. Sample Production Incident

### Issue

Users report that the application is responding slowly.

### Investigation

1. Checked application availability.
2. Checked server uptime.
3. Reviewed CPU utilization using `top`.
4. Identified a process consuming unusually high CPU.
5. Reviewed application logs.
6. Checked memory and disk utilization.
7. Verified application service status.
8. Identified the suspected resource-intensive process.
9. Followed the approved operational procedure for resolution.
10. Revalidated application performance.

### Validation

After the issue was addressed:

* CPU utilization returned to a normal range.
* Application response time improved.
* Application service remained available.
* No new application errors were observed.
* Users confirmed that the application was functioning normally.

---

## 14. Production Support Best Practices

* Always collect evidence before making changes.
* Check application logs before restarting services.
* Validate CPU, memory, disk, and network health.
* Identify the affected process or service before taking action.
* Follow incident and change-management procedures.
* Avoid unauthorized changes in production.
* Record investigation steps and observations.
* Validate the application after resolution.
* Document the root cause and preventive actions.
* Escalate to the appropriate team when the issue is outside the support scope.

---

## Skills Demonstrated

* Linux / Unix Server Troubleshooting
* CPU and Memory Monitoring
* Disk and Filesystem Monitoring
* Process Management
* Service Monitoring
* Network Connectivity Checks
* Application Log Analysis
* Production Incident Troubleshooting
* Root Cause Analysis
* Application Support
* Production Support

---

## Author

**Sunny Bhatt**

Application Support | Production Support | Linux | SQL | API Integration | AWS | Git/GitHub

