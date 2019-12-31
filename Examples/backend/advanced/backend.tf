###############################################################################################################
# BACKEND                                                                                                     #
# -------                                                                                                     #
# Once backend (storage account and sp) exists the backend can be migrated by using one of the following:     #
# File: terraform init -backend-config="backend-config.txt" (Check setup.log for values)                      #
# Partial using sas: terraform init -backend-config="sas_token=xyz" (Partial config)                          #
# Env: terraform init <after> $env:ARM_CLIENT_ID=""; $env:ARM_CLIENT_SECRET=""                                #
# NOTE: Variables cannot be used in "backend block"                                                           # 
###############################################################################################################
#terraform {
#    backend "azurerm" {
#        resource_group_name    = "check setup.log"
#        storage_account_name   = "check setup.log"
#        container_name         = "backend-remote-state"
#        key                    = "terraform.tfstate"
#        sas_token              = "optional method - not secure"
#    }
#}