# Local Provisioner - Runs on your local Macbook Pro/Linux instance to
# 1. Configure the local ~/.kube/config file for accessing the AKS cluster

# resource "local_file" "azurek8s" {
#   content    = azurerm_kubernetes_cluster.cluster.kube_config_raw
#   filename   = "${path.module}/azurek8s"
#   depends_on = [azurerm_kubernetes_cluster.cluster]
# }


resource "null_resource" "local_mac_provisioner" {
  provisioner "local-exec" {
    command = <<EOT
        echo ""
        echo "################################################################################"
        echo "# Running local provisioner to set KUBECONFIG"
        echo "################################################################################"
        echo ""
        #export KUBECONFIG=./azurek8s
        echo ""
        az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${var.cluster_name} --overwrite-existing  
        EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
    FILE=./azurek8s
    if [[ -f "$FILE" ]]; then
      rm $FILE
    fi
    EOT
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}