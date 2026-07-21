
## Overview
This document provides execution and setup details for implementing database change management system using Azure Database for PostgreSQL, GitHub Workflows & Actions and Liquibase open-source tool. 

This implementation architecture follows best practice of using same source code for deployments across multiple environments, purpose is to reduce or remove configuration drift across environments (like Dev, QA, Prod etc). Following is the architecture diagram of this setup:

<img width="1680" height="973" alt="image" src="https://github.com/user-attachments/assets/22cbc2fb-e549-4fb1-9c92-87d6693ab3fc" />


**Note**: The implementation architecture can be used across other databases like Azure HorizonDB, Oracle AI Database@Azure, SQL Server on VM etc.

#### Architecture Components:
- GitHub Repo : Contains the source codes like SQL execution scripts, GitHub workflow configuration files, Liquibase configuration and Changeset details.
- GitHub Actions : Contains events, workflow execution details, jobs and runner configuration details.
- GitHub Secrets : Used to store database connection details and credentials. E.g. Server endpoint, database name, user, password etc.
- Azure VM : Hosts multiple execution components - self-hosted GitHub Actions Runner, Database Client (like psql), Liquibase installation.
- Database Servers: Target database environment where SQLs have to be deployed.

#### Execution Chronology:
Following are the chronological steps performed during implementation:
1. Workflow is triggered automatically by commands like git push or PR merge etc.
2. Job is picked up by HTTPS poll of self-hosted runner.
3. Source code is checked out over https by runner in a temporary directory on Azure VM (where actinos-runner is hosted).
4. Credentials are delivered as package over HTTPS. 
5. Runner uses Liquibase configuration to deploy database change sets to target DB server using private connection.

## Environment Setup
#### Pre-requisite:
There are some pre-requisites to implement Database Change Management using Azure Database for PostgreSQL, GitHub Actions and Liquibase tool. Following Azure resources should be ready before starting with the remaining steps of this document.
- Azure VNet with Public Subnet.
- Azure Database for PostgreSQL deployed on public VNet.

#### GitHub Repository:
This repo will contain all SQL, Liquibase Changelog & Properties and GitHub Actions Workflow files. Following should be the structure of the folders and files inside of this repo:

<img width="612" height="715" alt="image" src="https://github.com/user-attachments/assets/3fe393ff-da89-4a8c-8f5e-5fa0b1c6f019" />

Root folder (the repository itself) should contain 3 directories and 1 file as mentioned below:
- **postgres_changelog** - This folder will contain Liquibase changelog files written in Liquiase formatted SQL. It would contain PostgreSQL native SQL statements that have to be applied to database and their corresponding ROLLBACK statements along with "author" and "version number" as shown below:

<img width="1396" height="988" alt="image" src="https://github.com/user-attachments/assets/4cb8b3d6-85d6-4f4b-a967-6fa95aafe86d" />

- **postgres_sql_scripts (optional)** - Individual SQL statements in changeset file stored separately for backup, fallback and tracking purposes.
-  **.github/workflows** - Workflow scripts in YAML format for continuous integration, deployment, rollback and schema drift across multiple database environments.
-  **liquibase.properties** - Liquibase configuration file as shown below:

<img width="1310" height="945" alt="image" src="https://github.com/user-attachments/assets/d5a80ce8-adb7-47c8-a71a-fb56afaebf24" />

#### Azure VM for GitHub Runner, Liquibase & PSQL CLI:
Before configuring Azure VM, make sure you have Azure VNet with public subnet already provisioned.

Launch an Azure VM in the public subnet above. VM should be created using following configuration 
- VM Image - "Ubuntu Server" with "x64" VM architecture.
- Size - Minimum 2 vCPU and 8 GB memory.
- Authentication type - "Password". Provide user name and corresponding password and keep them safe.
- Public inbound ports - "Allow selected ports"
- Select inbound ports - "SSH (22)"
- Disks - Keep everything as default.
- Networking - Use virtual network and public created by you.

Keep everything as-is with their default values and press "Review + Create" and then "Create". Once created SSH into the VM using user and password provided in "Authenticantion type" while setting up VM. 

Install following tools one-by-one:
- **Install "psql" client for PostgreSQL** - Execute the commands mentioned below in sequence. The final command should show an output like this:
  
<img width="967" height="38" alt="image" src="https://github.com/user-attachments/assets/0d7831cb-54b8-4c86-91c2-0100c2e29abc" />

```
sudo apt update
sudo apt install -y postgresql-client
psql --version
```

- **Install and setup GitHub runner** - Use GitHub repo, settings, actions, runners and new self-hosted runner options to get commands to install GitHub Actions Runner in Azure VM. Use "Runner image" as "Linux", copy the corresponding commands for "Download" and "Configure". Execute them sequentially in Azure VM. While configuring runner in VM, use "postgres-runner" in the option mentioned as "Enter any additional labels".
  
<img width="2259" height="1235" alt="image" src="https://github.com/user-attachments/assets/43f4e410-359b-4f6f-8a2a-130db1ce03b3" />


<img width="1998" height="1193" alt="image" src="https://github.com/user-attachments/assets/f7c20a44-c72f-4246-87af-3b7634bb7cb2" />

Use the following commands one-by-one to install GitHub Actions runner as service

```
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
```

Once all the commands are executed go back to GitHub Repo -> Settings -> Actions -> Runners, you should the runner running as shown below:

<img width="1666" height="372" alt="image" src="https://github.com/user-attachments/assets/583759de-db1c-458c-9f9e-1dceda226589" />


- **Install and configure Liquibase tool** - Liquibase is a database change management tool with proper version control, rollback and drift detection support. Liquibase tool has a pre-requisite of JDK, "openjdk" can be used for the same. 

Execute following commands to install Liquibase DCM tool. The final command should show output as below:
**Liquibase Version: 4.27.0**

**Note**: It will install Liquibase version 4.27. If a different version is needed, then Liquibase URL should be changed accordingly in the 3rd command below.
```
cd ~ 
sudo apt update
sudo apt install -y openjdk-17-jdk
wget https://github.com/liquibase/liquibase/releases/download/v4.27.0/liquibase-4.27.0.tar.gz
tar -xvzf liquibase-*.tar.gz
sudo ln -s $(pwd)/liquibase /usr/local/bin/liquibase
liquibase --version 
```

## Execution steps
### Resources:
Download all resources from this GitHub repo. Copy the files (as shown below) in corresponding folders of your repo.

<img width="883" height="883" alt="image" src="https://github.com/user-attachments/assets/9e2550af-4367-4cb6-93da-a374118ef322" />

### Database Credentials:
Use GitHub Secrets to setup database credentials. 

<img width="2252" height="1239" alt="image" src="https://github.com/user-attachments/assets/a5822259-4d42-4d38-8978-271a46842970" />


Use following variables exactly as mentioned to setup database credentials. Name and case of variables should be exactly same, otherwise pipeline execution will fail.

Database URL should use following syntax. Replace variable '<AZ_PG_ENDPOINT>' with your Azure PostgreSQL endpoint and '<AZ_PG_DB>' with your database name.

```
jdbc:postgresql://<AZ_PG_ENDPOINT>:5432/<AZ_PG_DB>?sslmode=require
```

##### Dev Environment
```
DEV_DB_HOST
DEV_DB_NAME
DEV_DB_PASSWORD
DEV_DB_URL
DEV_DB_USER
```

##### QA Environment
```
QA_DB_HOST
QA_DB_NAME
QA_DB_PASSWORD
QA_DB_URL
QA_DB_USER
```
##### Dev Environment
```
DEV_DB_HOST
DEV_DB_NAME
DEV_DB_PASSWORD
DEV_DB_URL
DEV_DB_USER
```

##### PROD Environment
```
PROD_DB_HOST
PROD_DB_NAME
PROD_DB_PASSWORD
PROD_DB_URL
PROD_DB_USER
```

### Execute Automated Database Change Management:
To execute database changes using automatic change management follow the steps below.
1. Go to your repository.
2. Go to "Actions".
3. Select "PostgreSQL Validate Changelog CI (Liquibase Validate)" to validate changes in Azure PG.
4. Select "PostgreSQL Database Deployment (Liquibase CD)" to deploy changes in Azure PG.
5. Select "PostgreSQL Database Rollback (Liquibase Rollback CD)" to rollback changes that have been deployed in Azure PG.
6. Select "PostgreSQL Database Schema Drift (Liquibase CI)" to check schema difference between two environments in Azure PG.

<img width="2257" height="1013" alt="image" src="https://github.com/user-attachments/assets/18f67b63-d485-43d8-b5d9-b1298542101c" />

**Input for "PostgreSQL Validate Changelog CI (Liquibase Validate)":**
- Target environment: Select "dev", "qa" or "prod" based on your requirement.

<img width="1718" height="880" alt="image" src="https://github.com/user-attachments/assets/0d575f03-a97c-4ca4-a126-27771084cda6" />

**Input for "PostgreSQL Database Deployment (Liquibase CD)":**
- Target environment: Select "dev", "qa" or "prod" based on your requirement.
- Tag: "Extremely" important to track changes and perform Rollback. Provide the "tag" or "version" for this deployment. Rollback cannot be done without tags.

<img width="1340" height="789" alt="image" src="https://github.com/user-attachments/assets/f4d60add-457f-4e23-b022-ea3eace12b44" />


**Input for "PostgreSQL Database Rollback (Liquibase Rollback CD)":**
- Target environment: Select "dev", "qa" or "prod" based on your requirement.
- Tag: Provide the "tag" or "version" to rollback to.

<img width="1349" height="799" alt="image" src="https://github.com/user-attachments/assets/2c6bd995-af3d-4f5e-8581-9ebf69931d99" />


**Input for "PostgreSQL Database Schema Drift (Liquibase CI)":**
- Baseline environment: Source environment for comparison. Select "dev", "qa" or "prod" based on your requirement.
- Comparing environment: Target environment for comparison. Cannot be same as source. Select "dev", "qa" or "prod" based on your requirement.

<img width="1354" height="792" alt="image" src="https://github.com/user-attachments/assets/13123115-4125-4f3e-bd87-10d22ad104e8" />
