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
