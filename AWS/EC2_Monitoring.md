# AWS EC2 Monitoring

## Overview

Amazon EC2 (Elastic Compute Cloud) provides resizable virtual servers in the AWS cloud.

This document demonstrates a practical approach to monitoring and troubleshooting an EC2 instance from an Application Support / Production Support perspective.

The focus is on:

* EC2 instance health
* CPU and resource monitoring
* Network monitoring
* Disk and filesystem checks
* Linux server health
* Application availability
* CloudWatch metrics
* Basic connectivity troubleshooting
* Security group awareness
* Incident investigation

> **Portfolio Note:** This document represents hands-on learning and portfolio practice completed as part of AWS training. The examples are designed to demonstrate troubleshooting methodology and should not be interpreted as professional production AWS experience.

---

## 1. EC2 Components

Important EC2 components that a Production/Application Support engineer should understand:

| Component      | Purpose                                           |
| -------------- | ------------------------------------------------- |
| EC2 Instance   | Virtual server running the application            |
| AMI            | Template used to launch an EC2 instance           |
| Instance Type  | Defines CPU, memory, and network capacity         |
| VPC            | Provides network isolation                        |
| Subnet         | Network segment where the instance runs           |
| Security Group | Controls inbound and outbound traffic             |
| EBS            | Persistent block storage attached to the instance |
| CloudWatch     | Monitoring and metrics service                    |

---

# 2. EC2 Instance Health Checks

Before troubleshooting an application issue, verify the health of the EC2 instance.

### Instance State

Check whether the instance is:

* Running
* Stopped
* Pending
* Rebooting
* Terminated

An application cannot be available if the EC2 instance is not running.

---

## 3. EC2 Status Checks

EC2 provides automated status checks to identify infrastructure problems.

### System Status Check

Checks the underlying AWS infrastructure supporting the instance.

Possible issues include:

* Hardware problems
* Network connectivity problems
* Power-related infrastructure issues

### Instance Status Check

Checks the operating system and instance-level health.

Possible issues include:

* OS boot problems
* Network configuration issues
* Resource exhaustion
* Kernel-level problems

### Status Check Failed

If an EC2 status check fails:

1. Check the EC2 console.
2. Identify whether the system or instance check failed.
3. Review recent instance events.
4. Check CloudWatch metrics.
5. Check application and operating system logs if the instance is accessible.
6. Follow the approved recovery procedure.

> Avoid restarting, stopping, or terminating an instance unless the action is authorized and follows the applicable change-management process.

---

# 4. Linux Server Health Checks

For Linux-based EC2 instances, basic OS health checks can help identify the source of application issues.

### Check system uptime

```bash
uptime
```

### Check CPU and running processes

```bash
top
```

### Check memory

```bash
free -m
```

### Check filesystem usage

```bash
df -h
```

### Check inode usage

```bash
df -i
```

### Check running processes

```bash
ps -ef
```

### Check listening ports

```bash
ss -tulnp
```

These checks help determine whether the issue is related to:

* CPU
* Memory
* Disk
* Processes
* Network ports
* Application availability

---

# 5. CloudWatch Monitoring

Amazon CloudWatch can be used to monitor EC2 resource metrics.

Important metrics include:

| Metric            | Purpose                            |
| ----------------- | ---------------------------------- |
| CPUUtilization    | Measures CPU usage                 |
| NetworkIn         | Incoming network traffic           |
| NetworkOut        | Outgoing network traffic           |
| DiskReadOps       | Disk read operations               |
| DiskWriteOps      | Disk write operations              |
| StatusCheckFailed | Indicates failed EC2 status checks |

---

## 6. CPU Monitoring

High CPU utilization can cause:

* Slow application response
* API timeouts
* Increased transaction processing time
* Application failures
* User complaints

### Investigation Approach

1. Check CPUUtilization in CloudWatch.
2. Identify when CPU usage increased.
3. Check whether the increase is continuous or temporary.
4. Log in to the Linux server if access is available.
5. Run:

```bash
top
```

6. Identify processes consuming high CPU.
7. Review application logs.
8. Check scheduled jobs or batch processes.
9. Correlate the timing with the reported application issue.

---

# 7. Memory Monitoring

Memory pressure can impact application performance.

Run:

```bash
free -m
```

Review:

* Total memory
* Used memory
* Available memory
* Swap usage

Additional process-level investigation:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
```

High memory consumption should be correlated with:

* Application processes
* Background jobs
* Batch processing
* Memory-intensive operations
* Recent application changes

---

# 8. Disk Monitoring

A full filesystem can cause application failures.

Check disk utilization:

```bash
df -h
```

Check inode utilization:

```bash
df -i
```

If disk usage is high, identify large directories:

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail
```

Common causes include:

* Application logs
* System logs
* Temporary files
* Large reports
* Uncontrolled log generation

> Do not delete production files or logs without authorization and an approved cleanup procedure.

---

# 9. Network Monitoring

Network problems can make an otherwise healthy EC2 instance appear unavailable.

Check listening ports:

```bash
ss -tulnp
```

Test basic connectivity:

```bash
ping <hostname>
```

Test HTTP connectivity:

```bash
curl -I http://<hostname>:<port>
```

Test HTTPS connectivity:

```bash
curl -I https://<hostname>
```

Check DNS resolution:

```bash
nslookup <hostname>
```

---

# 10. Security Group Awareness

An EC2 Security Group controls network traffic to and from the instance.

Important concepts:

* Inbound rules
* Outbound rules
* Protocol
* Port
* Source/destination
* Least-privilege access

For example, if an application listens on port `8080`, the required network path must allow the appropriate traffic.

When troubleshooting connectivity:

1. Confirm the application is running.
2. Confirm the application is listening on the expected port.
3. Check the Security Group.
4. Check subnet/network configuration.
5. Check whether the client can reach the instance.
6. Validate the application endpoint.

> Do not open ports broadly to the internet as a troubleshooting shortcut. Security rules should follow least-privilege principles.

---

# 11. EBS Storage Monitoring

Amazon EBS provides block storage for EC2 instances.

When investigating storage-related problems, check:

* Available disk space
* Filesystem usage
* Inode usage
* Application log growth
* Attached storage configuration
* Disk read/write activity

Linux checks:

```bash
df -h
```

```bash
df -i
```

Disk activity can also be reviewed through CloudWatch metrics such as:

* DiskReadOps
* DiskWriteOps

---

# 12. Application Availability Check

After confirming that the EC2 instance is healthy, verify the application.

Example:

```bash
curl -I http://<hostname>:<port>
```

For an HTTPS application:

```bash
curl -I https://<hostname>
```

Review:

* HTTP status code
* Response time
* Connectivity
* Application process
* Listening port
* Application logs

Example status codes:

| Status | Meaning               |
| ------ | --------------------- |
| 200    | Successful request    |
| 400    | Bad request           |
| 401    | Unauthorized          |
| 403    | Forbidden             |
| 404    | Resource not found    |
| 500    | Internal server error |
| 502    | Bad gateway           |
| 503    | Service unavailable   |
| 504    | Gateway timeout       |

---

# 13. Troubleshooting Scenario 1 – High CPU

### Problem

Users report that the application is responding slowly.

### Investigation

1. Check CloudWatch CPUUtilization.
2. Confirm whether CPU usage is continuously high.
3. Connect to the Linux server.
4. Run:

```bash
top
```

5. Identify the high-CPU process.
6. Review application logs.
7. Check scheduled jobs and batch processing.
8. Correlate the event with the application slowdown.

### Possible Root Cause

A resource-intensive application process is consuming excessive CPU.

### Resolution Approach

* Identify the responsible process.
* Validate whether it is an expected process.
* Follow the approved operational procedure.
* Monitor CPU after corrective action.
* Confirm application response time has returned to normal.

### Validation

```bash
uptime
```

```bash
top
```

Also verify the application endpoint:

```bash
curl -I https://<hostname>
```

---

# 14. Troubleshooting Scenario 2 – EC2 Status Check Failed

### Problem

The application is unavailable.

### Investigation

1. Open the EC2 console.
2. Check instance state.
3. Review system status checks.
4. Review instance status checks.
5. Check recent EC2 events.
6. Review CloudWatch metrics.
7. If the server is accessible, check OS health.
8. Follow the approved recovery process.

### Possible Causes

* Underlying AWS infrastructure issue
* OS-level issue
* Network configuration problem
* Resource exhaustion

### Validation

After recovery:

* EC2 instance status is healthy.
* Application process is running.
* Required port is listening.
* Application endpoint responds successfully.
* Users can access the application.

---

# 15. Troubleshooting Scenario 3 – Disk Full

### Problem

The application starts generating errors or fails to write data.

### Investigation

Run:

```bash
df -h
```

Then:

```bash
df -i
```

Identify large directories:

```bash
du -sh /var/log/* 2>/dev/null | sort -h | tail
```

Review:

* Application logs
* System logs
* Temporary files
* Log rotation
* Large files

### Possible Root Cause

Excessive application log generation caused filesystem utilization to reach a critical level.

### Resolution Approach

Follow the approved disk-cleanup or storage-expansion procedure.

### Validation

Confirm:

```bash
df -h
```

Then verify:

* Application can write files.
* Application is responding normally.
* Log generation is working correctly.
* Disk utilization remains within the defined threshold.

---

# 16. Troubleshooting Scenario 4 – Application Unreachable

### Problem

Users cannot access the application hosted on EC2.

### Investigation Flow

```text
User Reports Issue
       |
       v
Check EC2 Instance State
       |
       v
Check EC2 Status Checks
       |
       v
Check Application Process
       |
       v
Check Listening Port
       |
       v
Check Security Group
       |
       v
Check Network/DNS
       |
       v
Test Application Endpoint
       |
       v
Review Application Logs
       |
       v
Identify Root Cause
```

Useful commands:

```bash
ps -ef
```

```bash
ss -tulnp
```

```bash
curl -I http://<hostname>:<port>
```

```bash
nslookup <hostname>
```

---

# 17. Sample Portfolio Incident

## Incident: EC2 High CPU and Application Slowness

### Incident ID

`AWS-INC-001`

### Severity

High

### Environment

Production simulation / portfolio practice

### Symptoms

Users report slow application response.

### Monitoring Alert

CloudWatch indicates sustained high CPU utilization on the EC2 instance.

### Investigation

1. Reviewed EC2 instance state.
2. Checked CloudWatch CPU metrics.
3. Connected to the Linux instance.
4. Executed:

```bash
top
```

5. Identified a resource-intensive application process.
6. Reviewed application logs.
7. Correlated the CPU increase with the reported application slowdown.

### Root Cause

A resource-intensive application process caused sustained high CPU utilization.

### Resolution

The process was investigated and the appropriate corrective action was performed following the approved operational procedure.

### Validation

After corrective action:

* CPU utilization returned to an acceptable level.
* Application response time improved.
* Application endpoint returned a successful response.
* No new related errors were observed in the application logs.

### Preventive Actions

* Configure appropriate CloudWatch monitoring.
* Define CPU utilization thresholds.
* Review application resource consumption.
* Monitor recurring high-CPU processes.
* Document the incident and RCA.
* Establish preventive monitoring where applicable.

---

# 18. EC2 Troubleshooting Checklist

### Instance

* [ ] Instance is running
* [ ] System status check is healthy
* [ ] Instance status check is healthy
* [ ] Recent instance events reviewed

### CPU

* [ ] CloudWatch CPU reviewed
* [ ] `top` reviewed
* [ ] High-CPU process identified
* [ ] Application logs correlated

### Memory

* [ ] `free -m` checked
* [ ] High-memory processes reviewed

### Disk

* [ ] `df -h` checked
* [ ] `df -i` checked
* [ ] Large directories investigated
* [ ] Log growth reviewed

### Network

* [ ] Listening ports checked
* [ ] DNS resolution checked
* [ ] Connectivity tested
* [ ] Security Group reviewed

### Application

* [ ] Application process checked
* [ ] Application endpoint tested
* [ ] HTTP status reviewed
* [ ] Application logs reviewed

### Incident Management

* [ ] Impact identified
* [ ] Timeline documented
* [ ] Root cause identified
* [ ] Resolution documented
* [ ] Validation completed
* [ ] Preventive actions identified

---

# 19. Production Support Best Practices

1. Always determine the business impact before taking corrective action.
2. Follow incident severity and escalation procedures.
3. Collect evidence before making changes.
4. Use monitoring data to establish the timeline.
5. Correlate infrastructure, application, and database symptoms.
6. Avoid unauthorized production changes.
7. Follow change-management procedures for restart, configuration, or infrastructure changes.
8. Never commit AWS credentials, access keys, private keys, passwords, or tokens to GitHub.
9. Use least-privilege access.
10. Document the root cause and preventive actions after major incidents.

---

# 20. Skills Demonstrated

This portfolio exercise demonstrates practical understanding of:

* AWS EC2
* CloudWatch monitoring
* Linux server troubleshooting
* CPU and memory analysis
* Disk and filesystem monitoring
* Network troubleshooting
* Security Group concepts
* EBS storage concepts
* Application availability checks
* HTTP/API troubleshooting
* Incident Management
* Root Cause Analysis
* Production Support methodology
* Technical documentation
* Git/GitHub repository management

---

## Author

**Sunny Bhatt**

Application Support / Production Support

GitHub Portfolio Project – AWS & Production Support Practice
