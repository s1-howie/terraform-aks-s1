terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.0"
    }
  }

  required_version = ">= 0.14"
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.cluster.kube_config[0].host
    client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config[0].client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.cluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.cluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = "aks-s1-demo"
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  dns_prefix          = var.dns_prefix
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = var.kubernetes_version
  #
  # NOTE:  NEED TO REGISTER FOR THE AUTO UPGRADE PREVIEW
  # https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster
  #
  automatic_channel_upgrade = "stable"

  default_node_pool {
    name       = var.nodepool_name
    node_count = var.agent_count
    vm_size    = var.vm_size
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  tags = {
    Environment = "aks-s1-demo"
  }
}

resource "kubernetes_namespace" "s1" {
  metadata {
    name = var.s1_namespace
  }
  depends_on = [azurerm_kubernetes_cluster.cluster]
}

locals {
  dockerconfigjson = {
    "auths" = {
      (var.docker_server) = {
        username = var.docker_username
        password = var.docker_password
        auth     = base64encode(join(":", [var.docker_username, var.docker_password]))
      }
    }
  }
}

resource "kubernetes_secret" "s1" {
  metadata {
    name      = var.s1_repository_pull_secret_name
    namespace = var.s1_namespace
  }
  data = {
    ".dockerconfigjson" = jsonencode(local.dockerconfigjson)
  }
  type       = "kubernetes.io/dockerconfigjson"
  depends_on = [kubernetes_namespace.s1, azurerm_kubernetes_cluster.cluster]
}

resource "helm_release" "sentinelone" {
  name       = var.helm_release_name
  repository = "https://charts.sentinelone.com"
  chart      = "s1-agent"
  version    = var.helm_chart_version
  namespace  = kubernetes_namespace.s1.metadata[0].name
  set {
    name  = "secrets.imagePullSecret"
    value = var.s1_repository_pull_secret_name
  }
  set {
    name  = "configuration.repositories.helper"
    value = var.s1_helper_image_repository
  }
  set {
    name  = "configuration.tag.helper"
    value = var.s1_helper_image_tag
  }
  set {
    name  = "configuration.cluster.name"
    value = var.cluster_name
  }
  set {
    name  = "configuration.repositories.agent"
    value = var.s1_agent_image_repository
  }
  set {
    name  = "configuration.tag.agent"
    value = var.s1_agent_image_tag
  }
  set {
    name  = "secrets.site_key.value"
    value = var.s1_site_key
  }
  set {
    name  = "helper.nodeSelector\\.kubernetes.io/os'"
    value = "linux"
  }
  set {
    name  = "agent.nodeSelector\\.kubernetes.io/os'"
    value = "linux"
  }
  set {
    name  = "agent.resources.limits.cpu"
    value = var.agent_resources_limits_cpu
  }
  set {
    name  = "agent.resources.limits.memory"
    value = var.agent_resources_limits_memory
  }
  set {
    name  = "helper.resources.limits.cpu"
    value = var.helper_resources_limits_cpu
  }
  set {
    name  = "helper.resources.limits.memory"
    value = var.helper_resources_limits_memory
  }
  set {
    name  = "agent.resources.requests.cpu"
    value = var.agent_resources_requests_cpu
  }
  set {
    name  = "agent.resources.requests.memory"
    value = var.agent_resources_requests_memory
  }
  set {
    name  = "helper.resources.requests.cpu"
    value = var.helper_resources_requests_cpu
  }
  set {
    name  = "helper.resources.requests.memory"
    value = var.helper_resources_requests_memory
  }


  depends_on = [kubernetes_namespace.s1, kubernetes_secret.s1]
}

