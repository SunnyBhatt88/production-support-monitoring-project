# AWS S3 Troubleshooting

## Overview

Amazon Simple Storage Service (Amazon S3) is an object storage service used to store and retrieve data.

From an Application Support / Production Support perspective, S3 troubleshooting is important when an application cannot upload, download, read, or access objects stored in an S3 bucket.

This document demonstrates a practical approach to investigating:

* S3 buckets
* S3 objects
* IAM permissions
* Bucket policies
* AccessDenied errors
* Object-not-found errors
* Application-to-S3 connectivity
* Storage and lifecycle concepts
* S3 access troubleshooting
* Incident investigation

> **Portfolio Note:** This document represents hands-on learning and portfolio practice completed as part of AWS training. The examples demonstrate S3 concepts and troubleshooting methodology and should not be interpreted as professional production AWS experience.

---

# 1. What is Amazon S3?

Amazon S3 is an object storage service designed to store and retrieve data.

Common use cases include:

* Application files
* Reports
* Images
* Documents
* Backups
* Logs
* Data exports
* Static website content

A simplified application flow:

```text id="gk0z1d"
Application
     |
     v
S3 Bucket
     |
     v
S3 Object
     |
     v
Upload / Download / Read
```

---

# 2. S3 Components

| Component      | Purpose                                     |
| -------------- | ------------------------------------------- |
| Bucket         | Container used to store objects             |
| Object         | Individual file/data stored in S3           |
| Object Key     | Unique name/path used to identify an object |
| Prefix         | Logical grouping of objects                 |
| Region         | AWS region where the bucket is hosted       |
| Bucket Policy  | Resource-based policy controlling access    |
| IAM Policy     | Identity-based permission policy            |
| Lifecycle Rule | Automates object transitions or expiration  |

---

# 3. S3 Bucket

A bucket is a container for objects.

Example:

```text id="wm46is"
support-application-data
```

Objects can be organized using prefixes.

Example:

```text id="75lqcf"
support-application-data/
|
├── orders/
│   ├── order_10001.json
│   └── order_10002.json
|
├── reports/
│   └── daily_report.csv
|
└── logs/
    └── application.log
```

---

# 4. S3 Object

An object contains data and metadata.

Example object:

```text id="1u6tqp"
Bucket:
support-application-data

Object:
orders/order_10001.json
```

When troubleshooting an object-related issue, confirm:

* Bucket name
* Object key
* Region
* Object existence
* Access permissions
* Application identity

---

# 5. S3 Access Model

An application may access S3 through an IAM role.

Example:

```text id="j9h7x1"
Application
     |
     v
EC2 Instance
     |
     v
IAM Role
     |
     v
IAM Policy
     |
     v
S3 Bucket
     |
     v
S3 Object
```

The access request must satisfy the applicable permission controls.

---

# 6. IAM and S3 Permissions

Common S3 actions include:

```text id="f6d8xz"
s3:ListBucket
s3:GetObject
s3:PutObject
s3:DeleteObject
```

Their general purpose:

| Permission        | Purpose                  |
| ----------------- | ------------------------ |
| `s3:ListBucket`   | List objects in a bucket |
| `s3:GetObject`    | Read/download an object  |
| `s3:PutObject`    | Upload an object         |
| `s3:DeleteObject` | Delete an object         |

An application may require only a subset of these permissions.

For example, an application that only downloads files may require `s3:GetObject` but should not automatically receive delete permissions.

---

# 7. S3 Access Troubleshooting Workflow

```text id="zj9v8k"
Application Error
       |
       v
Identify Bucket
       |
       v
Identify Object Key
       |
       v
Identify IAM User / Role
       |
       v
Identify Failed S3 Action
       |
       v
Review IAM Policy
       |
       v
Review Bucket Policy
       |
       v
Check Explicit Deny
       |
       v
Check Region / Object Path
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

# 8. AccessDenied Error

One of the most common S3 problems is:

```text id="0f1y8m"
AccessDenied
```

Example:

```text id="w4zv4g"
Access Denied when performing s3:GetObject
```

### Investigation

1. Identify the application identity.
2. Identify the IAM role or user.
3. Identify the S3 action.
4. Identify the bucket.
5. Identify the object key.
6. Review IAM permissions.
7. Review the bucket policy.
8. Check for explicit deny.
9. Check applicable conditions.
10. Retest after an authorized change.

---

# 9. Example – S3 GetObject Failure

## Problem

An application running on EC2 cannot download a file from S3.

### Error

```text id="iyw5dn"
AccessDenied: User is not authorized to perform s3:GetObject
```

### Investigation

Application:

```text id="1z1qfg"
Order Processing Application
```

S3 bucket:

```text id="xg0b6h"
support-application-data
```

Object:

```text id="mbj9dy"
orders/order_10001.json
```

Required action:

```text id="h8s1jv"
s3:GetObject
```

### Investigation Steps

1. Identify the EC2 instance.
2. Identify the IAM role attached to the instance.
3. Review the IAM policy.
4. Confirm whether `s3:GetObject` is allowed.
5. Verify the object key.
6. Review the bucket policy.
7. Check for explicit deny.
8. Review applicable conditions.
9. Perform the approved remediation.
10. Retest the application.

### Possible Root Cause

The EC2 IAM role does not have permission to perform `s3:GetObject` against the required object.

### Resolution

An authorized administrator adds the required least-privilege permission according to the organization's access-management process.

### Validation

Confirm:

* Application can retrieve the object.
* No AccessDenied errors occur.
* Only required permissions are granted.
* Existing application functionality continues to work.

---

# 10. Object Not Found

Another common problem is an application reporting that an S3 object cannot be found.

Possible causes include:

* Incorrect bucket name
* Incorrect object key
* Incorrect prefix
* Object was moved
* Object was deleted
* Application is using the wrong environment
* Application is using the wrong AWS region
* Case-sensitive object-key mismatch

Example:

```text id="x8z2r9"
Expected:
orders/order_10001.json

Application requests:
orders/Order_10001.json
```

The object key does not match.

---

# 11. Troubleshooting Object-Key Issues

When an application cannot find an object:

### Verify

```text id="6jskk7"
Bucket Name
      |
      v
Region
      |
      v
Object Key
      |
      v
Prefix
      |
      v
Object Existence
```

Pay particular attention to:

* Uppercase/lowercase characters
* Spaces
* Special characters
* File extensions
* Folder/prefix names
* Environment-specific paths

---

# 12. Upload Failure

## Problem

An application cannot upload a file to S3.

### Possible Causes

* Missing `s3:PutObject`
* Incorrect bucket
* Incorrect object key
* Bucket policy restriction
* Explicit deny
* Incorrect credentials/role
* Encryption-related permission requirements
* Application configuration issue

### Investigation

1. Identify the application identity.
2. Identify the target bucket.
3. Identify the object key.
4. Identify the required S3 action.
5. Review IAM permissions.
6. Review bucket policy.
7. Check application logs.
8. Check whether encryption settings introduce additional permissions.
9. Retest after authorized remediation.

---

# 13. Upload Troubleshooting Flow

```text id="2o3lmb"
Upload Failure
      |
      v
Check Application Logs
      |
      v
Identify S3 Bucket
      |
      v
Identify Object Key
      |
      v
Identify IAM Identity
      |
      v
Check s3:PutObject
      |
      v
Check Bucket Policy
      |
      v
Check Explicit Deny
      |
      v
Check Encryption Requirements
      |
      v
Retest Upload
```

---

# 14. Download Failure

## Problem

Users cannot download a report generated by the application.

### Investigation

Check:

* Application logs
* S3 bucket
* Object key
* Object existence
* IAM role
* `s3:GetObject`
* Bucket policy
* Object permissions
* Application configuration

Example:

```text id="v0emgy"
User
 |
 v
Application
 |
 v
IAM Role
 |
 v
s3:GetObject
 |
 v
S3 Bucket
 |
 v
Report Object
```

---

# 15. Bucket Policy

A bucket policy is a resource-based policy associated with an S3 bucket.

It can control access based on:

* Principal
* Action
* Resource
* Conditions

Conceptual example:

```json id="o0iw2p"
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::123456789012:role/ApplicationRole"
  },
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::example-bucket/reports/*"
}
```

> This is a learning example only. Never copy account IDs, roles, bucket names, or permissions from examples into production without validating the actual environment and security requirements.

---

# 16. Explicit Deny

An explicit deny can prevent S3 access even when an Allow permission exists.

Example:

```json id="klj0a8"
{
  "Effect": "Deny",
  "Action": "s3:GetObject",
  "Resource": "*"
}
```

When troubleshooting access:

```text id="9r9x8c"
Allow Found
   |
   v
Check for Explicit Deny
   |
   +---- Deny Found ----> Access Denied
   |
   +---- No Deny -------> Continue Investigation
```

---

# 17. S3 Region Awareness

AWS resources operate within specific regions.

When troubleshooting S3 access, verify:

* Bucket region
* Application configuration
* AWS SDK configuration
* Endpoint configuration where applicable

A region mismatch can cause unexpected behavior or application errors.

Example:

```text id="q6u7n5"
Application Configuration
        |
        v
Expected Region
        |
        v
S3 Bucket Region
        |
        v
Compare
```

---

# 18. S3 Lifecycle Rules

S3 Lifecycle rules can automatically manage objects over time.

They can be used for:

* Storage class transitions
* Object expiration
* Cost optimization

Example:

```text id="6f0j1p"
Object Created
     |
     v
Standard Storage
     |
     v
Lifecycle Rule
     |
     v
Transition / Expiration
```

When an expected object is no longer available, support teams should consider whether a lifecycle or retention rule may be involved.

---

# 19. S3 Storage and Application Support

From a support perspective, S3 issues can affect:

* Order processing
* Report generation
* File imports
* File exports
* Document processing
* Data exchange
* Application integrations

Example:

```text id="u8b4ve"
Business Transaction
       |
       v
Application
       |
       v
Generate File
       |
       v
Upload to S3
       |
       v
Downstream Process
```

If the S3 upload fails, the downstream business process may also fail.

---

# 20. Application-to-S3 Incident

## Incident ID

`S3-INC-001`

## Severity

High

## Environment

Production simulation / portfolio practice

## Symptoms

A business process generates files, but downstream processing does not receive the expected file.

### Investigation

1. Confirm the business transaction.
2. Check application logs.
3. Identify the expected S3 bucket.
4. Identify the expected object key.
5. Check whether the object exists.
6. Identify the application IAM identity.
7. Review `s3:PutObject` permission.
8. Review bucket policy.
9. Check for explicit deny.
10. Validate application configuration.
11. Retest the file-generation process.

### Possible Root Cause

The application IAM role does not have the required permission to upload objects to the target S3 location.

### Resolution

The required least-privilege permission is reviewed and updated through the approved access-management process.

### Validation

* File generation succeeds.
* Object appears in the expected S3 location.
* Downstream processing receives the file.
* No new S3 access errors are observed.

### Preventive Actions

* Review IAM permissions.
* Document application-to-S3 dependencies.
* Monitor failed file transfers.
* Maintain appropriate application logging.
* Review access changes through change management.

---

# 21. S3 Security Best Practices

1. Follow least-privilege access.
2. Avoid unnecessary public access.
3. Do not store credentials in application code.
4. Never commit AWS access keys or secrets to GitHub.
5. Use IAM roles for AWS workloads where appropriate.
6. Review bucket policies regularly.
7. Restrict access to required buckets and objects.
8. Use encryption according to organizational requirements.
9. Review lifecycle and retention policies.
10. Monitor unusual access patterns.
11. Follow approved change-management procedures.
12. Do not delete production objects without authorization.
13. Avoid broad wildcard permissions where they are not required.

---

# 22. S3 Troubleshooting Checklist

### Bucket

* [ ] Correct bucket identified
* [ ] Correct AWS region confirmed
* [ ] Bucket exists
* [ ] Correct environment confirmed

### Object

* [ ] Correct object key confirmed
* [ ] Correct prefix confirmed
* [ ] Object existence checked
* [ ] Filename/case verified
* [ ] File extension verified

### IAM

* [ ] Application identity identified
* [ ] IAM role/user confirmed
* [ ] Required S3 action identified
* [ ] IAM policy reviewed
* [ ] Bucket policy reviewed
* [ ] Explicit deny checked
* [ ] Conditions reviewed where applicable

### Application

* [ ] Application logs reviewed
* [ ] S3 request failure identified
* [ ] Transaction/correlation ID captured
* [ ] Application configuration verified
* [ ] Upload/download retested

### Incident

* [ ] Business impact identified
* [ ] Timeline documented
* [ ] Root cause identified
* [ ] Resolution documented
* [ ] Validation completed
* [ ] Preventive actions identified

---

# 23. S3 Troubleshooting Workflow

```text id="y8qz3j"
Business Issue
      |
      v
Application Logs
      |
      v
Identify S3 Operation
      |
      v
Identify Bucket + Object Key
      |
      v
Check Object
      |
      v
Identify IAM Identity
      |
      v
Check IAM Permissions
      |
      v
Check Bucket Policy
      |
      v
Check Explicit Deny
      |
      v
Check Region / Configuration
      |
      v
Apply Approved Resolution
      |
      v
Retest
      |
      v
Validate Business Process
      |
      v
Document RCA
```

---

# 24. Production Support Perspective

S3 troubleshooting should focus on both the technical and business impact.

A support engineer should determine:

* What business process is affected?
* Which application is making the S3 request?
* Which IAM identity is being used?
* What S3 operation failed?
* Which bucket and object are involved?
* Is the object available?
* Are permissions correct?
* Is there an explicit deny?
* Is the region/configuration correct?
* Has the issue been validated after resolution?

This approach helps resolve S3 issues efficiently while maintaining security and operational controls.

---

# 25. Skills Demonstrated

This portfolio exercise demonstrates practical understanding of:

* Amazon S3
* S3 Buckets
* S3 Objects
* Object Keys and Prefixes
* IAM and S3 integration
* IAM Roles
* IAM Policies
* Bucket Policies
* AccessDenied troubleshooting
* S3 Upload/Download troubleshooting
* Region awareness
* Lifecycle concepts
* Application-to-S3 integration
* Incident Management
* Root Cause Analysis
* Production Support methodology
* Security best practices
* Technical documentation
* Git/GitHub

---

## Author

**Sunny Bhatt**

Application Support / Production Support

GitHub Portfolio Project – AWS & Production Support Practice
