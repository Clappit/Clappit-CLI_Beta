# Clappit: Bulletproof Your Infrastructure Drift and Testing

Clappit is a next-generation cloud management platform designed to revolutionize how you manage your cloud infrastructure.

**Features**

1.  **Intuitive Infrastructure Definition:** Define your entire AWS environment with simple, readable code. Deploy with confidence and speed.
2.  **Seamless Connectivity:** Visualize and manage all your cloud resources in one place, ensuring smooth communication and data flow between components.
3.  **Reliable Infrastructure Testing:** Automatically verify your infrastructure's configuration and functionality. Identify potential issues before they impact your operations.
4.  **Effortless State Snapshots:** Easily capture, compare, and roll back to previous configurations, providing peace of mind and flexibility in managing your cloud resources.
5.  **Proactive Drift Detection:** Stay on top of changes in your infrastructure and identify unauthorized modifications, ensuring compliance and security.

## Prerequisites

***if any challenges with installation, please feel to reach [Support](/support.md)***

1.  **Docker:** A containerization platform. [**Download and install Docker**](https://docs.docker.com/get-docker/)
    
    *(Not required if you already have a Kubernetes cluster running locally)*
    
2.  **kind (Kubernetes in Docker):** A tool for running local Kubernetes clusters using Docker container "nodes." [**Install kind**](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
    
    *(Not required if you already have a Kubernetes cluster running locally)*
    
3.  **kubectl:** The Kubernetes command-line tool for running commands against Kubernetes clusters. [**Install kubect**](https://kubernetes.io/docs/tasks/tools/)
    
4.  **Helm:** A package manager for Kubernetes. [**Install Helm**](https://helm.sh/docs/intro/install/](https://helm.sh/docs/intro/install/ )

5. **Crossplane:** Crossplane operator and providers as helm package instalation
   
   *Crospplane Operator*
    ```bash
    helm repo add crossplane-stable https://charts.crossplane.io/stable
    helm repo update
    helm install crossplane --namespace crossplane-system crossplane-stable/crossplane --create-namespace
    ```
    
    After crossplane oeprator is ready, install providers
    ```bash
    helm install xproviders oci://index.docker.io/clappit/xproviders --version 0.1.0 -n crossplane-system --create-namespace
    ```

### **Alternative Installation (Linux/macOS):**

1.  Download the appropriate script:
    
    -   Ubuntu: [install\_tools\_ubuntu.sh](/installation/install\_tools\_ubuntu.sh)
        
    -   macOS: [install\_tools\_mac.sh](/installation/install\_tools\_mac.sh)
        
2.  Open a terminal, navigate to the download folder, and run:
    
    ```bash
    bash install_tools_ubuntu.sh 
    # or
    bash install_tools_mac.sh
    ```

## Installing Clappit

***if any challenges with installation, please feel to reach [Support](/support.md)***

1.  **Download Clappit:**
    
    Choose the appropriate download for your operating system and architecture from the provided links.

    - [Download for MacBook (arm 64 - Silicon Processor - M1, M2, M3)](https://clappit-public.s3.us-west-2.amazonaws.com/clappit-osx-arm64.zip)
    - [Download for MacBook (x64 - Intel Processor)](https://clappit-public.s3.us-west-2.amazonaws.com/clappit-osx-x64.zip)
    - [Download for Ubuntu (arm64)](https://clappit-public.s3.us-west-2.amazonaws.com/clappit-linux-arm64.zip)
    - [Download for Ubuntu (x64)](https://clappit-public.s3.us-west-2.amazonaws.com/clappit-linux-x64.zip)
    - [Download for Windows (arm64)](https://clappit-public.s3.us-west-2.amazonaws.com/clappit-win-arm64.zip)
    - [Download for Windows (x64)](https://clappit-public.s3.us-west-2.amazonaws.com/clappit-win-x64.zip)


2.  **Install Clappit:**
    
    **Linux/macOS:**
    
    ```bash
    bash setup_macos.sh  
    # or
    bash setup_ubuntu.sh
    ```
    
    **OR** 

    **(Manual Installation):**
    
    1.  Extract the downloaded Clappit executable.
    2.  Open a terminal and navigate to the extracted folder.
    3.  Make the Clappit executable:
        
        ```bash
        chmod +x clappit
        ```
        
    4.  Add Clappit to your PATH:
        
        ```bash
        export PATH="$PATH:/path/to/clappit" 
        ```
        
        (Replace `/path/to/clappit` with the actual path)
        

**Windows:**

1.  Extract the contents of the downloaded zip file.
2.  Open a command prompt or PowerShell.
3.  Navigate to the extracted folder using the `cd` command.
4.  Ensure the `clappit.exe` file is in the extracted folder.
5.  Add the extracted folder to your system's PATH environment variable.

3.  **Verify Installation:**
    
    ```bash
    clappit --version
    ```
    

**Congratulations! You've successfully installed Clappit!**

# Clappit Command Line Tool User Guide

Welcome to the Clappit Command Line Tool User Guide. 

---

## Table of Contents

-  [ Getting Started](\#getting-started)
-   [Commands](\#commands)
    -   [Create](\#create)
    -   [Update](\#update)
    -   [Delete](\#delete)
    -   [Show](\#show)
    -   [Liveness](\#liveness)
    -   [Sync](\#sync)
    -   [Check](\#check)
    -   [Help](\#help)

## Getting Started

Before you begin using the Clappit tool, ensure that it is properly installed on your system. Follow the installation guide provided with the tool for setup instructions.

## Commands

The Clappit tool organizes its functionality into categories, each containing a set of related commands. Below are the branches and their respective commands.

### Create

-   **app**: Create a new application.
    
    *Usage* : `clappit create app <APPNAME>`
    
    *Example*
    
    ```
    clappit create app myapp
    ```
    
-   **service**: Create a new service.
    
    *Usage* : `clappit create svc <SVCNAME>`
    
    *Example*
    
    ```
    clappit create svc mysvc
    ```
    

### Update

-   **app**: 
    
    **infra cluster**: Updates the application infrastructure (kubernetes clsuter) details 
    
    *Usage* : `clappit update app <APPNAME> infra <ENV> cluster -e=<CLUSTERNAME>.`
    
    *Example*
    
    ```
    clappit update app myapp infra qa cluster -e=myk8scluster
    ```
    
-   **svc**: 
    
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

-   **app**: Deletes the application 
    
    *Usage* : `clappit delete app -a=<APPNAME>`
    
    *Example*
    
    ```
    clappit delete app -a=myapp
    ```
    
-   **appinfra**: Deletes the application infrastructure.
    
    *Usage* : `clappit delete appinfra -a=<APPNAME> -e=<ENVNAME>`
    
    *Example*
    
    ```
    clappit delete appinfra -a=myapp -e=qa
    ```
    
-   **svc**: Deletes the the service
    
    *Usage* : `clappit delete svc -a=<APPNAME> -s=<SVCNAME>`
    
    *Example*
    
    ```
    clappit delete svc -a=myapp -s=mysvc
    ```
    
-   **svcinfra**: Deletes the service infrastructue
    
    *Usage* : `clappit delete svcinfra -a=<APPNAME> -s=<SVCNAME> -e=<ENV>`
    
    *Example*
    
    ```
    clappit delete svc -a=myapp -s=mysvc -e=qa
    ```
    

### Show

-   **service-graph**: Shows the services and their depedencies.
    
    *Usage* : `clappit show service-graph -a=<APPNAME>`
    
    *Example*
    
    ```
    Example: clappit show service-graph -a=myapp
    ```
    
-   **service-deps**: Shows dependents of purticular service.
    
    *Usage* : `clappit show service-deps -a=<APPNAME> -s=<SVCNAME>`
    
    *Example*
    
    ```
    Example: clappit show service-deps -a=myapp -s=mysvc
    ```
    

### Liveness

-   **service-deps**:

    *Usage* : `clappit liveness -a=<APPNAME> -e=<ENVNAME>`

*Example*

```
Example: clappit liveness -a=myapp -e=dev
```

### Sync

- **sync**: Syncs the infrastructure configurations, can be saved as a snapshot, showing drift if there are any configuration differences.

*Usage* : `clappit sync -a=<APPNAME> -e=<ENVNAME> [--diff] [--save] -q=<QUIET>`

*Example*

```
Example: clappit sync -a=myapp -e=dev --diff --save -q=false
```

### Import

- **import**: Imports and connects cloud infrastructure.

*Usage* : `clappit import -a=<APPNAME> -e=<ENVNAME> <CLOUD> -r=<region> -i=<ACCESSID> -k=<ACCESSKEY>`

*Example*

```
Example: clappit import -a=myapp -e=dev aws -r=us-east-1 -i=1234567890 -k=1234567890
```

### Check

- **pre-req**: Verifies that all prerequisites are installed to run the CLI.

*Usage* : `clappit check pre-req`

### Help

- **help**: Prints help information with command usage and examples at any level.

*Examples*

 ![Screenshot of create app help](clappit-help.png?raw=true "create app")

 ![Screenshot of update app help](clappit-help1.png?raw=true "create app")
