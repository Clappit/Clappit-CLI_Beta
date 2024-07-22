# Clappit: Your Cloud, Simplified

Clappit is the next-generation cloud management platform designed to revolutionize how you manage your cloud infrastructure. With an intuitive interface and powerful automation, Clappit empowers you to: 

**Features**

1. **Intuitive Infrastructure Definition:** Define your entire AWS environment with simple, readable code. Deploy with confidence and speed.

2. **Seamless Connectivity:** Visualize and manage all your cloud resources in one place. Ensure smooth communication and data flow between components.

3. **Reliable Infrastructure Testing:** Automatically verify your infrastructure's configuration and functionality.Identify potential issues before they impact your operations.

4. **Effortless State Snapshots:** Capture, compare, and roll back to previous configurations with ease. Gain peace of mind and flexibility in managing your cloud resources.

5. **Proactive Drift Detection:** Stay on top of changes in your infrastructure and identify unauthorized modifications.Ensure compliance and security.

### Prerequisites

1. **Docker**: A containerization platform. [Download and install Docker](https://docs.docker.com/get-docker/).

_if there is kubernetes cluster this step wouldn`t be required_

2. **kind (Kubernetes in Docker)**: A tool for running local Kubernetes clusters using Docker container "nodes". [Install kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation).

_if there is kubernetes cluster this step wouldn`t be required_

3. **kubectl**: The Kubernetes command-line tool, allows you to run commands against Kubernetes clusters. [Install kubectl](https://kubernetes.io/docs/tasks/tools/).

4. **Helm**: A package manager for Kubernetes. [Install Helm](https://helm.sh/docs/intro/install/).

### Installing Clappit

After installing the prerequisites, you can proceed with the installation of Clappit. Follow these steps:

1. **Download Clappit**: Visit the Clappit official website or the GitHub repository to download the latest version of Clappit.

2. **Install Clappit**:
   - On **Linux/macOS**, open a terminal and run:
     ```bash
     chmod +x clappit_installer.sh
     ./clappit_installer.sh
     ```
   - On **Windows**, download the installer and follow the on-screen instructions.

3. **Verify Installation**:
   - To verify that Clappit has been installed correctly, run:
     ```bash
     clappit --version
     ```
   - You should see the installed version of Clappit displayed in the terminal.

Congratulations! You have successfully installed Clappit and its prerequisites. You are now ready to simplify your cloud management.

# Clappit Command Line Tool User Guide

Welcome to the Clappit Command Line Tool User Guide. 

---

## Table of Contents

- [Getting Started](#getting-started)
- [Commands](#commands)
  - [Create](#create)
  - [Update](#update)
  - [Delete](#delete)
  - [Show](#show)
  - [Liveness](#liveness)
  - [Sync](#sync)
  - [Check](#check)
  - [Help](#help)


## Getting Started

Before you begin using the Clappit tool, ensure that it is properly installed on your system. Follow the installation guide provided with the tool for setup instructions.

## Commands

The Clappit tool organizes its functionality into categories, each containing a set of related commands. Below are the branches and their respective commands.

### Create

- **app**: Create a new application.

  *Usage* : `clappit create app <APPNAME>`

  *Example*
  ```
  clappit create app myapp
  ```

- **service**: Create a new service.

  *Usage* : `clappit create svc <SVCNAME>`

  *Example*
  ```
  clappit create svc mysvc
  ```

### Update

- **app**: 

  **infra cluster**: Updates the application infrastructure (kubernetes clsuter) details 

  *Usage* : `clappit update app <APPNAME> infra <ENV> cluster -e=<CLUSTERNAME>.`

  *Example*
  ```
  clappit update app myapp infra qa cluster -e=myk8scluster

  ```

- **svc**: 

  **dependencies**: Updates the service dependenices

  *Usage* : `clappit update svc <SVCNAME> dependencies -s=<DEPSVC1>,<DEPSVC2>.`

  *Example*
  ```
  clappit update svc mysvc dependencies -s=svc1,svc2

  ```

  **infra database**: Updates infrastructure configuration for service type database

  *Usage* : `clappit update svc <SVCNAME> infra <ENV> database -e=<INFRARESOURCENAME>.`

  *Example*
  ```
  clappit update svc mysvc infra qa database -e=myawsrds
  ```

  **infra k8sservice**: Updates infrastructure configuration for service type k8sservice

  *Usage* : `clappit update svc <SVCNAME> infra <ENV> k8sservice -e=<INFRARESOURCENAME>.`

  *Example*
  ```
  clappit update svc mysvc infra qa k8service -e=myawsrds
  ```

### Delete

- **app**: Deletes the application 

  *Usage* : `clappit delete app -a=<APPNAME>`

  *Example*
  ```
  clappit delete app -a=myapp
  ```

- **appinfra**: Deletes the application infrastructure.

  *Usage* : `clappit delete appinfra -a=<APPNAME> -e=<ENVNAME>`

  *Example*
  ```
  clappit delete appinfra -a=myapp -e=qa
  ```

- **svc**: Deletes the the service

  *Usage* : `clappit delete svc -a=<APPNAME> -s=<SVCNAME>`

  *Example*
  ```
  clappit delete svc -a=myapp -s=mysvc
  ```

- **svcinfra**: Deletes the service infrastructue

  *Usage* : `clappit delete svcinfra -a=<APPNAME> -s=<SVCNAME> -e=<ENV>`

  *Example*
  ```
  clappit delete svc -a=myapp -s=mysvc -e=qa
  ```

### Show

- **service-graph**: Shows the services and their depedencies.

  *Usage* : `clappit show service-graph -a=<APPNAME>`

  *Example*
  ```
  Example: clappit show service-graph -a=myapp
  ```

- **service-deps**: Shows dependents of purticular service.

  *Usage* : `clappit show service-deps -a=<APPNAME> -s=<SVCNAME>`

  *Example*
  ```
  Example: clappit show service-deps -a=myapp -s=mysvc
  ```

### Liveness

- **service-deps**: Shows the liveness of infrastructure resources of purticular environment

  *Usage* : `clappit liveness -a=<APPNAME> -e=<ENVNAME>`

  *Example*
  ```
  Example: clappit liveness -a=myapp -e=dev
  ```

### Sync

- **sync**: Syncs the infrastructure configurations, can be save as snapshot with showing drift if any configuration.

  *Usage* : `clappit sync -a=<APPNAME> -e=<ENVNAME> [--diff] [--save] -q=<QUIET>`

  *Example*
  ```
  Example: clappit sync -a=myapp -e=dev --diff --save -q=false
  ```

### Import

- **import**: imports and connects cloud infrastructure.

  *Usage* : `clappit sync -a=<APPNAME> -e=<ENVNAME> [--diff] [--save] -q=<QUIET>`

  *Example*
  ```
  Example: clappit sync -a=myapp -e=dev --diff --save -q=false

  ```

### Check 

- **pre-req**: Verifies all pre-requisites are installed to run CLI

  *Usage* : `clappit check pre-req`


### Help

- **help**: Prints the help with command usage along with example on any level

  *Examples*


  ![Screenshot of create app help](clappit-help.png?raw=true "create app")

  ![Screenshot of update app help](clappit-help1.png?raw=true "create app")
