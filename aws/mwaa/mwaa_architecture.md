# MWAA Architecture Diagram

## MWAA Architecture Summary

The architecture shows a fully managed Apache Airflow environment in AWS with the following components:

• **MWAA Environment**: Running Airflow 2.9.2 on mw1.small class with 2 workers, 2 schedulers, and 2 webservers
• **Networking**: Deployed in a private VPC (dev-eu-west-1-data-science-dev) with two private subnets
• **Security**: Protected by a security group that allows self-referencing traffic and HTTPS from the 10.0.0.0/8 CIDR range
• **Storage**: Uses an S3 bucket (dsai-airflow-dags) for DAGs and requirements with versioning enabled
• **Encryption**: KMS key for S3 bucket encryption with key rotation enabled
• **IAM**: Custom execution role with permissions for S3, CloudWatch, SQS, KMS, Secrets Manager, ECS, and ECR
• **Monitoring**: CloudWatch log groups for DAG processing, scheduler, task, webserver, and worker logs

The environment is configured for private access only, meaning the Airflow UI is only accessible from within the VPC or through VPC endpoints.

You can view the complete diagram and details in the created file. Would you like me to explain any specific aspect of the architecture in more detail?
```mermaid
graph TD
    %% Main VPC
    VPC["VPC: dev-eu-west-1-data-science-dev<br>CIDR: 10.234.176.0/20<br>ID: vpc-06048e6e821493c73"]
    
    %% Subnets
    SUBNET1["Private Subnet 1<br>ID: subnet-010bd220674c2e8ac"]
    SUBNET2["Private Subnet 2<br>ID: subnet-07a6ba292a26afc9b"]
    
    %% Security Group
    SG["Security Group: dsai-dev-sg<br>ID: sg-0bc5a43c0513592f7"]
    
    %% S3 Bucket
    S3["S3 Bucket: dsai-airflow-dags<br>Versioning: Enabled<br>SSE: KMS"]
    
    %% KMS Key
    KMS["KMS Key<br>ID: 5d0e2925-acb9-4604-8e86-9f347e9dc823<br>Rotation: Enabled"]
    
    %% IAM Role
    IAM["IAM Role: dsai-dev-mwaa-execution-role<br>Service: airflow.amazonaws.com"]
    
    %% MWAA Environment
    MWAA["MWAA Environment: dsai-dev-mwaa<br>Airflow Version: 2.9.2<br>Environment Class: mw1.small"]
    
    %% CloudWatch Log Groups
    CW_LOGS["CloudWatch Log Groups<br>- DAG Processing<br>- Scheduler<br>- Task<br>- WebServer<br>- Worker"]
    
    %% Connections
    VPC --> SUBNET1
    VPC --> SUBNET2
    SUBNET1 --> MWAA
    SUBNET2 --> MWAA
    SG --> MWAA
    S3 --> MWAA
    KMS --> S3
    IAM --> MWAA
    MWAA --> CW_LOGS
    
    %% Styling
    classDef aws fill:#FF9900,stroke:#232F3E,color:#232F3E
    classDef network fill:#7AA5D7,stroke:#232F3E,color:#232F3E
    classDef security fill:#D86613,stroke:#232F3E,color:#232F3E
    classDef storage fill:#277BC0,stroke:#232F3E,color:#232F3E
    classDef compute fill:#EC7211,stroke:#232F3E,color:#232F3E
    classDef monitoring fill:#BC6EB0,stroke:#232F3E,color:#232F3E
    
    class VPC,SUBNET1,SUBNET2 network
    class SG,IAM,KMS security
    class S3 storage
    class MWAA compute
    class CW_LOGS monitoring
```

## Architecture Details

### VPC and Networking
- **VPC**: dev-eu-west-1-data-science-dev (vpc-06048e6e821493c73)
- **CIDR Block**: 10.234.176.0/20
- **Private Subnets**: 
  - subnet-010bd220674c2e8ac
  - subnet-07a6ba292a26afc9b
- **Security Group**: dsai-dev-sg (sg-0bc5a43c0513592f7)
  - Allows self-referencing traffic
  - Allows inbound HTTPS (443) from 10.0.0.0/8
  - Allows all outbound traffic

### Storage
- **S3 Bucket**: dsai-airflow-dags
  - Versioning: Enabled
  - Server-Side Encryption: KMS
  - Contains DAGs, requirements.txt

### Security
- **KMS Key**: 5d0e2925-acb9-4604-8e86-9f347e9dc823
  - Used for S3 bucket encryption
  - Key rotation enabled
- **IAM Role**: dsai-dev-mwaa-execution-role
  - Service principals: airflow-env.amazonaws.com, airflow.amazonaws.com, ecs-tasks.amazonaws.com
  - Permissions for S3, CloudWatch Logs, SQS, KMS, Secrets Manager, ECS, ECR

### MWAA Environment
- **Name**: dsai-dev-mwaa
- **Airflow Version**: 2.9.2
- **Environment Class**: mw1.small
- **Workers**: Min 2, Max 2
- **Schedulers**: 2
- **Webservers**: Min 2, Max 2
- **Access Mode**: PRIVATE_ONLY

### Monitoring
- **CloudWatch Log Groups**:
  - airflow-dsai-dev-mwaa-DAGProcessing
  - airflow-dsai-dev-mwaa-Scheduler
  - airflow-dsai-dev-mwaa-Task
  - airflow-dsai-dev-mwaa-WebServer
  - airflow-dsai-dev-mwaa-Worker
