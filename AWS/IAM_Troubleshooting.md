# AWS IAM Troubleshooting

## Overview

AWS Identity and Access Management (IAM) is used to control access to AWS resources.

From an Application Support / Production Support perspective, IAM troubleshooting is important when an application, user, or AWS service cannot access a required resource.

This document demonstrates a practical approach to investigating:

* IAM users
* IAM groups
* IAM roles
* IAM policies
* Access denied errors
* EC2 IAM roles
* Permission issues
* Least-privilege access
* Authentication vs authorization problems

> **Portfolio Note:** This document represents hands-on learning and portfolio practice completed as part of AWS training. The examples demonstrate IAM concepts and troubleshooting methodology and should not be interpreted as professional production AWS experience.

---

# 1. What is AWS IAM?

AWS Identity and Access Management (IAM) helps control:

**Who** can access AWS resources and **what actions** they are allowed to perform.

A simplified model is:

```text
Identity
   |
   v
IAM Policy
   |
   v
Permission Evaluation
   |
   v
AWS Resource
   |
   v
Allow / Deny
```

Examples of AWS resources include:

* EC2
* S3
* RDS
* CloudWatch
* SNS
* SQS

---

# 2. IAM Components

| Component    | Purpose                                               |
| ------------ | ----------------------------------------------------- |
| IAM User     | Represents an individual identity                     |
| IAM Group    | Collection of IAM users                               |
| IAM Role     | Identity that can be assumed by users or AWS services |
| IAM Policy   | Defines permissions                                   |
| AWS Resource | Resource being accessed                               |

---

# 3. IAM User

An IAM user represents a specific identity that can access AWS resources.

A user may have:

* Console access
* Programmatic access
* Group membership
* Direct permissions through policies

For example:

```text
Support_User
     |
     +-- CloudWatch Read Access
     |
     +-- EC2 Read Access
     |
     +-- S3 Read Access
```

For support teams, access should be provided according to job responsibilities.

---

# 4. IAM Groups

IAM groups allow permissions to be assigned to multiple users.

Example:

```text
Production-Support Group
        |
        +-- User A
        +-- User B
        +-- User C
```

The group can have policies attached to it.

This makes access management easier than maintaining separate permissions for every user.

---

# 5. IAM Roles

An IAM role is an identity that can be assumed when access is required.

Roles are commonly used by:

* EC2 instances
* AWS services
* Applications
* Users
* Federated identities

For example:

```text
EC2 Instance
      |
      v
IAM Role
      |
      v
IAM Policy
      |
      v
S3 Access
```

This allows an application running on EC2 to access AWS resources without storing long-term AWS credentials on the server.

---

# 6. IAM Policies

IAM policies define permissions.

A policy specifies:

* Effect
* Action
* Resource
* Optional conditions

Basic structure:

```json id="w0o7tq"
{
  "Effect": "Allow",
  "Action": "service:Action",
  "Resource": "resource-identifier"
}
```

Example of a read-only style permission:

```json id="a1qk0e"
{
  "Effect": "Allow",
  "Action": [
    "cloudwatch:GetMetricData",
    "cloudwatch:ListMetrics"
  ],
  "Resource": "*"
}
```

> This is an example for learning purposes. Actual production policies should be designed according to organizational security requirements.

---

# 7. Allow and Deny

IAM permissions are evaluated based on applicable policies.

A simplified concept is:

```text
Request
   |
   v
Authentication
   |
   v
Permission Evaluation
   |
   +---- Explicit Deny ---> DENY
   |
   +---- Allow -----------> ALLOW
   |
   +---- No Allow --------> DENY
```

An explicit deny takes precedence over an allow.

Therefore, when investigating an access problem, do not check only whether an Allow policy exists. Also look for applicable Deny rules or other permission boundaries.

---

# 8. Authentication vs Authorization

Understanding the difference is important during troubleshooting.

### Authentication

Answers:

**Who are you?**

Examples:

* Username/password
* IAM credentials
* Federated login

### Authorization

Answers:

**What are you allowed to do?**

Examples:

* Read an S3 object
* Start an EC2 instance
* View CloudWatch metrics

Simplified:

```text
Authentication
      |
      v
Identity Confirmed
      |
      v
Authorization
      |
      v
Permission Check
      |
      v
Access Granted / Denied
```

---

# 9. Common IAM Errors

One of the most common IAM-related errors is:

```text id="6r7d2x"
AccessDenied
```

Examples:

```text
User is not authorized to perform: s3:GetObject
```

or:

```text
User is not authorized to perform: ec2:DescribeInstances
```

or:

```text
AccessDeniedException
```

These errors generally indicate a permission or authorization issue.

---

# 10. IAM Troubleshooting Workflow

Use a structured approach:

```text id="m3tdj5"
Access Issue
     |
     v
Identify User / Role
     |
     v
Identify AWS Service
     |
     v
Identify Failed Action
     |
     v
Review IAM Policies
     |
     v
Check Resource Permissions
     |
     v
Check Explicit Deny
     |
     v
Check Conditions / Boundaries
     |
     v
Apply Approved Change
     |
     v
Retest
     |
     v
Document Resolution
```

---

# 11. Step 1 – Identify the Identity

First determine which identity is making the request.

It could be:

* IAM user
* IAM role
* EC2 instance role
* Application role
* Federated identity

Example:

```text
Identity:
production-support-role
```

Do not assume that the logged-in console user is the identity used by an application.

---

# 12. Step 2 – Identify the AWS Service

Determine which AWS service is involved.

Examples:

```text
EC2
S3
CloudWatch
RDS
SNS
SQS
```

Example problem:

```text
Application cannot retrieve an object from S3.
```

The investigation should focus on:

```text
Application
   |
   v
IAM Role
   |
   v
S3 Permission
   |
   v
S3 Bucket/Object
```

---

# 13. Step 3 – Identify the Failed Action

Determine exactly what action is being denied.

Examples:

```text
s3:GetObject
ec2:DescribeInstances
cloudwatch:GetMetricData
s3:ListBucket
```

This is important because IAM permissions are action-specific.

For example, permission to read an S3 object does not automatically mean permission to delete it.

---

# 14. Step 4 – Review IAM Policies

Check applicable policies associated with:

* User
* Group
* Role

Look for:

* Required action
* Correct resource
* Allow statement
* Conditions
* Explicit deny

Example:

```text
Required Action:
s3:GetObject

Policy:
s3:GetObject

Result:
Permission may be available
```

If the required action is not allowed, an authorized IAM administrator may need to update the policy.

---

# 15. Step 5 – Check Resource-Level Permissions

Some AWS resources have their own resource-based policies or access controls.

For example, S3 can involve:

* IAM policies
* S3 bucket policies
* Object ownership/access configuration

Therefore:

```text
IAM Policy
     +
Resource Policy
     +
Other applicable controls
     |
     v
Final Permission Decision
```

The support engineer should consider all applicable permission layers.

---

# 16. Step 6 – Check Explicit Deny

If an expected Allow exists, check whether another applicable policy contains:

```json id="d6v9zi"
{
  "Effect": "Deny"
}
```

An explicit deny can override an allow.

Potential sources include:

* Identity policies
* Resource policies
* Permission boundaries
* Service control policies in AWS Organizations
* Other applicable policy controls

---

# 17. Step 7 – Check Policy Conditions

IAM policies can contain conditions.

Examples include restrictions based on:

* Source IP
* AWS region
* Resource tags
* Secure transport
* MFA
* Request context

Therefore, a policy may contain an Allow statement but still deny access because the request does not satisfy the required condition.

---

# 18. IAM Policy Simulator

The IAM Policy Simulator can help evaluate whether a particular identity is allowed to perform an action.

A simplified troubleshooting process:

```text
Identity
   |
   v
Select AWS Service
   |
   v
Select Action
   |
   v
Select Resource
   |
   v
Evaluate
   |
   v
Allowed / Denied
```

This can help narrow down permission problems before making changes.

---

# 19. EC2 IAM Role Troubleshooting

Applications running on EC2 may need access to AWS services.

For example:

```text
Application on EC2
       |
       v
EC2 IAM Role
       |
       v
IAM Policy
       |
       v
S3
```

If the application cannot access S3:

### Check

1. Is the EC2 instance running?
2. Is the expected IAM role attached?
3. Does the role contain the required permission?
4. Is the resource correct?
5. Is there an explicit deny?
6. Are policy conditions satisfied?
7. Is the application using the expected AWS identity?
8. Retest after an approved change.

---

# 20. Example EC2 + S3 Access Issue

## Problem

An application running on EC2 cannot retrieve an S3 object.

### Error

```text id="w2a4fc"
AccessDenied: User is not authorized to perform s3:GetObject
```

### Investigation

1. Identify the EC2 instance.
2. Identify the IAM role attached to the instance.
3. Review the role policies.
4. Check whether `s3:GetObject` is allowed.
5. Verify the target S3 bucket/object.
6. Check the S3 bucket policy.
7. Check for explicit deny statements.
8. Review any applicable conditions.
9. Retest after authorized remediation.

### Possible Root Cause

The EC2 role does not have the required S3 object-read permission.

### Resolution

An authorized administrator updates the IAM policy according to the least-privilege requirement.

### Validation

Confirm that:

* EC2 has the expected role.
* Required permission is available.
* Application can access the required object.
* No unauthorized permissions were introduced.

---

# 21. IAM Access Denied Scenario

## Incident ID

`IAM-INC-001`

## Severity

Medium

## Environment

Production simulation / portfolio practice

## Symptoms

A support application receives an `AccessDenied` error while attempting to retrieve monitoring information.

### Investigation

The support engineer:

1. Identifies the application identity.
2. Identifies the IAM role being used.
3. Identifies the denied AWS action.
4. Reviews the IAM policies.
5. Checks for explicit deny.
6. Reviews applicable conditions.
7. Confirms the required permission.
8. Performs an authorized permission update if required.
9. Retests the application.

### Root Cause

The IAM role did not have the required read permission for the requested CloudWatch operation.

### Resolution

The required least-privilege permission was added through the approved access-management process.

### Validation

* Application request succeeds.
* No AccessDenied errors are observed.
* Existing permissions remain unchanged.
* Monitoring functionality works as expected.

### Preventive Actions

* Review IAM permissions regularly.
* Use least-privilege policies.
* Avoid unnecessary wildcard permissions.
* Document access requirements.
* Review permission changes through change management.

---

# 22. Least Privilege

The principle of least privilege means providing only the permissions required to perform a task.

### Poor Example

```json id="sh5yqm"
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

This grants extremely broad access and should generally be avoided.

### Better Approach

Grant only the required action against the required resource.

Conceptually:

```text
Required Task
     |
     v
Required Service
     |
     v
Required Action
     |
     v
Required Resource
```

---

# 23. IAM Security Best Practices

1. Follow the principle of least privilege.
2. Avoid unnecessary administrator-level access.
3. Avoid wildcard permissions where they are not required.
4. Use IAM roles for AWS workloads where appropriate.
5. Do not store AWS access keys in application source code.
6. Never commit AWS credentials or secrets to GitHub.
7. Use approved secret-management mechanisms.
8. Review permissions periodically.
9. Use MFA where required by organizational policy.
10. Document permission changes.
11. Follow change-management procedures for production IAM changes.
12. Investigate unexpected access-denied events.
13. Remove unnecessary access promptly when approved.
14. Separate development, test, and production access appropriately.

---

# 24. Troubleshooting Checklist

### Identity

* [ ] Correct IAM user identified
* [ ] Correct IAM role identified
* [ ] EC2 role verified where applicable
* [ ] Application identity confirmed

### Permission

* [ ] AWS service identified
* [ ] Failed action identified
* [ ] Required resource identified
* [ ] IAM policy reviewed
* [ ] Resource policy reviewed where applicable
* [ ] Explicit deny checked
* [ ] Conditions checked
* [ ] Permission boundary considered
* [ ] Organization-level restrictions considered where applicable

### Resolution

* [ ] Required permission confirmed
* [ ] Least privilege maintained
* [ ] Change approved
* [ ] Permission updated by authorized person
* [ ] Application retested
* [ ] Incident documented

---

# 25. IAM Troubleshooting Example

```text id="q3tqpf"
Application
     |
     v
AccessDenied Error
     |
     v
Identify IAM Identity
     |
     v
Identify AWS Service
     |
     v
Identify Failed Action
     |
     v
Review IAM Policy
     |
     +------> Required Allow Missing
     |                 |
     |                 v
     |          Request Approved Change
     |
     +------> Explicit Deny
     |                 |
     |                 v
     |          Investigate Deny Source
     |
     v
Check Resource Policy
     |
     v
Check Conditions
     |
     v
Retest
     |
     v
Validate Application
     |
     v
Document RCA
```

---

# 26. Production Support Perspective

IAM troubleshooting is not only about adding permissions.

A good support investigation should answer:

* Who is making the request?
* Which AWS service is involved?
* Which action failed?
* Which resource is being accessed?
* Which policy controls the access?
* Is there an explicit deny?
* Are policy conditions involved?
* Is the application using the expected role?
* What is the minimum permission required?
* Was the change properly authorized?

This structured approach helps resolve access issues without introducing unnecessary security risks.

---

# 27. Skills Demonstrated

This portfolio exercise demonstrates practical understanding of:

* AWS IAM
* IAM Users
* IAM Groups
* IAM Roles
* IAM Policies
* Access Control
* Authentication vs Authorization
* AccessDenied troubleshooting
* EC2 IAM roles
* S3 access concepts
* CloudWatch permission concepts
* Least-privilege principles
* Security best practices
* Incident troubleshooting
* Production Support methodology
* Root Cause Analysis
* Technical documentation
* Git/GitHub

---

## Author

**Sunny Bhatt**

Application Support / Production Support

GitHub Portfolio Project – AWS & Production Support Practice
