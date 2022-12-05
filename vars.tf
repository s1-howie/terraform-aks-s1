variable "client_id" {
  description = "The client_id that K8s uses when creating Azure load balancers.  Can be the same as the client_id that terraform uses to create the cluster."
}

variable "client_secret" {
  description = "The client_secret that K8s uses when creating Azure load balancers.  Can be the same as the client_secret that terraform uses to create the cluster."
}

variable "resource_group_name" {
  description = "Name of the Resource Group to create."
  default     = "aks-s1-rg"
}
variable "location" {
  description = "The preferred Region in which to launch the resources outlined in this template."
  default     = "eastus"
}
variable "cluster_name" {
  description = "Cluster name for the AKS cluster"
  default     = "aks-s1-demo"
}

variable "dns_prefix" {
  description = "The DNS prefix that forms part of the FQDN used to access the cluster.  dns_prefix must contain between 2 and 45 characters. The name can contain only letters, numbers, and hyphens. The name must start with a letter and must end with an alphanumeric character."
  default     = "aks-s1-demo"
}

variable "agent_count" {
  description = "Number of worker nodes for the cluster."
  default     = "2"
}

variable "kubernetes_version" {
  description = "The version of Kuberentes to use."
  default     = "1.25.2"
}

variable "vm_size" {
  description = "Azure VM size to use for the K8s worker nodes."
  default     = "Standard_D2s_v3"
}

variable "nodepool_name" {
  description = "The name to be used for the AKS cluster's nodepool."
  default     = "s1nodepool"
}

variable "s1_repository_pull_secret_name" {
  description = "This is the NAME of the K8s secret that stores your credentials used to authenticate to your container image repository (where the s1-agent and s1-helper container images are stored.)"
  default     = "s1-repo-pull-secret"
}

variable "s1_helper_image_repository" {
  description = "The image/package repository where the s1_helper image is located."
}

variable "s1_helper_image_tag" {
  description = "Tag name (version) of the s1_helper image we want to use"
  default     = "ga-22.3.3"
}

variable "s1_agent_image_repository" {
  description = "The image/package repository where the s1_agent image is located."
}

variable "s1_agent_image_tag" {
  description = "Tag name (version) of the s1_agent image we want to use"
  default     = "ga-22.3.3"
}

variable "helm_chart_version" {
  description = "The version of the s1-agent chart to use"
}

variable "s1_site_key" {
  description = "The Sentinel One Site Key that the K8s agent will use when communicating with the S1 portal."
}

variable "s1_namespace" {
  description = "K8s namespace into which we will place the S1 K8s agent(s)"
  default     = "s1"
}

variable "docker_server" {
  description = "Base Repo that houses the S1 container images"
}

variable "docker_username" {
  description = "Username/ID to access the package/image repository (where the s1-agent and s1-helper images are housed)."
}

variable "docker_password" {
  description = "Password to access the package/image repository (where the s1-agent and s1-helper images are housed)."
}

variable "helm_release_name" {
  description = "Helm Releaes Name to use for the Helm deployment"
  default     = "s1"
}

variable "agent_resources_limits_cpu" {
  description = "CPU Limit to be applied to the s1-agent pod."
  default     = "900m"
}

variable "agent_resources_limits_memory" {
  description = "Memory Limit to be applied to the s1-agent pod."
  default     = "1.9Gi"
}

variable "helper_resources_limits_cpu" {
  description = "CPU Limit to be applied to the s1-helper pod."
  default     = "900m"
}

variable "helper_resources_limits_memory" {
  description = "Memory Limit to be applied to the s1-helper pod."
  default     = "1.9Gi"
}

variable "agent_resources_requests_cpu" {
  description = "CPU Request to be applied to the s1-agent pod."
  default     = "100m"
}

variable "agent_resources_requests_memory" {
  description = "Memory Request to be applied to the s1-agent pod."
  default     = "100Mi"
}

variable "helper_resources_requests_cpu" {
  description = "CPU Request to be applied to the s1-helper pod."
  default     = "100m"
}

variable "helper_resources_requests_memory" {
  description = "Memory Request to be applied to the s1-helper pod."
  default     = "100Mi"
}