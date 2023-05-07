resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.region
}

resource "azurerm_app_service_plan" "asp" {
  name                = var.aspname
  location            = local.region
  resource_group_name = local.resource_group_name
  kind                = var.appsvcos
  reserved            = true
  sku {
    tier = var.asptier
    size = var.aspsize
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_application_insights" "ai" {
  name                = var.ainame
  location            = local.region
  resource_group_name = local.resource_group_name
  application_type    = var.appinsighttype
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_app_service" "appsvc" {
  app_service_plan_id = azurerm_app_service_plan.asp.id
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = "InstrumentationKey=${azurerm_application_insights.ai.instrumentation_key};IngestionEndpoint=https://${local.region}-8.in.applicationinsights.azure.com/;LiveEndpoint=https://${local.region}.livediagnostics.monitor.azure.com/"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "default"
  }
  client_affinity_enabled = false
  client_cert_enabled     = false
  enabled                 = true
  https_only              = true
  location                = local.region
  name                    = var.aspname
  resource_group_name     = local.resource_group_name
  tags                    = {}

  auth_settings {
    additional_login_params        = {}
    allowed_external_redirect_urls = []
    enabled                        = false
    token_refresh_extension_hours  = 0
    token_store_enabled            = false
  }

  site_config {
    acr_use_managed_identity_credentials = false
    always_on                            = true
    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html",
    ]
    dotnet_framework_version    = "v4.0"
    ftps_state                  = "FtpsOnly"
    http2_enabled               = false
    ip_restriction              = []
    linux_fx_version            = "JAVA|17-java17"
    local_mysql_enabled         = false
    managed_pipeline_mode       = "Integrated"
    min_tls_version             = "1.2"
    number_of_workers           = 1
    remote_debugging_enabled    = false
    remote_debugging_version    = "VS2019"
    scm_ip_restriction          = []
    scm_use_main_ip_restriction = false
    use_32_bit_worker_process   = true
    vnet_route_all_enabled      = false
    websockets_enabled          = false
  }
  depends_on = [
    azurerm_app_service_plan.asp,
    azurerm_application_insights.ai,
    azurerm_resource_group.rg
  ]
}