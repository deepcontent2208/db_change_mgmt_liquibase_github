# db_change_management_implementation
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
#### GitHub Repository:
This repo will contain all SQL, Liquibase Changelog & Properties and GitHub Actions Workflow files. Following should be the structure of the folders and files inside of this repo:

<img width="612" height="715" alt="image" src="https://github.com/user-attachments/assets/3fe393ff-da89-4a8c-8f5e-5fa0b1c6f019" />

Root folder (Repo name itself) should contain 3 directories as mentioned below:
- postgres_changelog - This folder will contain Liquibase changelog files written in Liquiase formatted SQL. It would contain PostgreSQL native SQL statements that have to be applied to database and their corresponding ROLLBACK statements along with "author" and "version number" as shown below:

<img width="1396" height="988" alt="image" src="https://github.com/user-attachments/assets/4cb8b3d6-85d6-4f4b-a967-6fa95aafe86d" />

- 
-  

