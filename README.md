# terraform-aks-s1
A terraform template to create a basic AKS cluster and auto-install the SentinelOne Agent for K8s (CWPP).

## Detailed Description

This terraform template is designed to facilitate the creation of a 'vanilla' Azure AKS cluster for usage with testing/demos/etc.
It will create:
- A new Azure Resource Group which will contain all associated resources
- An AKS cluster with 2 worker nodes (by default)
- Create a new namespace to house the SentinelOne K8s resources
- Create a new K8s secret within the above-mentioned namespace that contains the credentials needed to pull the S1 images
- A helm deployment of the SentinelOne Agent for K8s

The template has a local-exec provisioner that will take care of setting the KUBECONFIG environment variable in order to access the cluster via kubectl from your local MBP/Linux workstation.

# Azure Pre-Requisites
- An Azure account with Azure AD permissions to create Service Principals (App Registrations)

# Local MBP/Linux workstation Pre-Requisites
- git v2.32+ (https://git-scm.com/downloads)
- terraform v0.14+ (https://www.terraform.io/downloads.html)
- azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- kubectl v1.21+ (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- (optional) helm 3.0+ (https://helm.sh/docs/intro/install/)

On a MBP, you can easily install all of these pre-requisites with:
```
brew update && brew install git terraform azurecli kubectl helm
```

# Setting up terraform to communicate with Azure
We need to create a new Service Principal for terraform in order for terraform to authenticate to Azure:
1. log into Azure
```
az login
```
2. Find your current account ID with (ie: The value of the "id" key):
```
az account list
```
3. Create a new Service Principal with Contributor permissions for terraform with (Replacing "SUBSCRIPTION_ID below with your account ID you noted from the above command):
```
az ad sp create-for-rbac \
  -n "http://terraform-aks-s1"
  --role="Contributor" \
  --scopes="/subscriptions/SUBSCRIPTION_ID"
```
4. Make a note of the values for appId and password. You need those to set up Terraform (in your terraform.tfvars file.  NOTE: appID == client_id and password == client_secret)


# Usage
1. Clone this repository
```
git clone https://github.com/s1-howie/terraform-aks-s1.git
```
2. Edit the variables in the sample 'terraform.tfvars.removeme' file to suit your environment

3. Remove the '.removeme' extension from terraform.tfvars.removeme so that the filename reads as: terraform.tfvars

4. Initialize terraform
```
terraform init
```
5. Run 'terraform apply' to execute the template
```
terraform apply
```
   This process typically takes 5-10 minutes.

6. Review the resources that will be created by the template and type "yes" to proceed.
   Once the template completes creating all resources, you should be able to use kubectl to manage your new cluster.
```
kubectl cluster-info
```
```
kubectl get nodes
```
```
kubectly get pods -A
```

# Cleaning up
After you've finished with your cluster, you can destroy/delete it (to keep your Azure bill as low as possible)
```
terraform destroy -auto-approve
```
   This process typically takes 5-10 minutes.
