###########################
# CONFIGURATION
###########################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"

    }
  }
}

###########################
# LOCALS
###########################
locals {
    tags = {
    WorkloadName            = "TBD"
    DataClassification      = "TBD"
    BusinessCriticality     = "TBD"
    BusinesUnit             = "TBD"
    OperationsCommitment    = "TBD"
    OperationsTeam          = "TBD"
  }
}

###########################
# VARIABLES
###########################

variable "resource_group_name" {
  type = string
  description = "Resource group name to place the virutal network"
  default = "rg-nonprod-cac-network-01"
}

variable "region" {
  type        = string
  description = "Region in Azure"
  default     = "canadacentral"
}

variable "vnet_name" {
  description = "Name of the vnet to create."
  type        = string
  default     = "vnet-nonprod-cac-spoke-01"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = string
  default     = "10.69.16.0/20"
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.69.16.0/23","10.69.18.0/23"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["subnet1","subnet2"]
}

###########################
# PROVIDERS
###########################

provider "azurerm" {
  features {}
}

###########################
# RESOURCES
###########################

data "azurerm_resource_group" "rg-vnet" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg-vnet.name
  location            = data.azurerm_resource_group.rg-vnet.location
  address_space       = [var.address_space]
  dns_servers = ["10.131.252.18", "10.141.252.18"]
  tags = local.tags
}

resource "azurerm_subnet" "subnets" {
    count = length(var.subnet_names)
    name = var.subnet_names[count.index]
    resource_group_name = data.azurerm_resource_group.rg-vnet.name
    address_prefixes = [ var.subnet_prefixes[count.index] ]
    virtual_network_name = azurerm_virtual_network.vnet.name
}
