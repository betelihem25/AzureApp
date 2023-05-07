variable "aspname" {
  description = "The name of the AppService"
  type        = string
  default     = "appservicejavaapp"
}

variable "asptier" {
  description = "The AppService Plan tier"
  type        = string
  default     = "Basic"
}

variable "aspsize" {
  description = "The Size of the AppService Plan"
  type        = string
  default     = "B1"
}

variable "ainame" {
  description = "The AppInsights Name"
  type        = string
  default     = "appinsightsjavaapp"
}

variable "appinsighttype" {
  description = "The Size of the AppService Plan"
  type        = string
  default     = "web"
}

variable "appsvcos" {
  description = "The Operating system of the App Service Plan"
  type        = string
  default     = "Linux"
}