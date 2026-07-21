# db_change_management_implementation
## Overview
This document provides execution and setup details for implementing database change management system using Azure Database for PostgreSQL, GitHub Workflows & Actions and Liquibase open-source tool. 

This implementation architecture follows best practice of using same source code for deployments across multiple environments, purpose is to reduce or remove configuration drift across environments (like Dev, QA, Prod etc). Following is the architecture diagram of this setup:

<img width="1680" height="973" alt="image" src="https://github.com/user-attachments/assets/22cbc2fb-e549-4fb1-9c92-87d6693ab3fc" />


**Note**: The implementation architecture can be used across other databases like Azure HorizonDB, Oracle AI Database@Azure, SQL Server on VM etc.

## Networking
