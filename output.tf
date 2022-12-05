# output "kube_config" {
#   value = azurerm_kubernetes_cluster.cluster.kube_config_raw
#   sensitive = true
# }

output "host" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  sensitive = true
}

output "kubeconfig_cmd" {
  value = "export KUBECONFIG=${path.cwd}/azurek8s"
}

output "az_aks_kubeconfig" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${var.cluster_name} --overwrite-existing"
}