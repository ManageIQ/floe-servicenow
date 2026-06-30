{
  "Comment": "ServiceNow Service Catalog API Examples - Demonstrates catalog browsing and item ordering",
  "StartAt": "GetCatalogs",
  "States": {
    "GetCatalogs": {
      "Type": "Task",
      "Resource": "servicenow://service_catalog/get_catalogs",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "limit": 5
      },
      "ResultPath": "$.catalogs",
      "Next": "GetCatalogItems"
    },
    "GetCatalogItems": {
      "Type": "Task",
      "Resource": "servicenow://service_catalog/get_items",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "limit": 10
      },
      "ResultPath": "$.catalog_items",
      "Next": "GetCatalogItem"
    },
    "GetCatalogItem": {
      "Type": "Task",
      "Resource": "servicenow://service_catalog/get_item",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "item_id.$": "$.catalog_items.result[0].sys_id"
      },
      "ResultPath": "$.item_detail",
      "Next": "SubmitCatalogItem"
    },
    "SubmitCatalogItem": {
      "Type": "Task",
      "Resource": "servicenow://service_catalog/submit_catalog_item",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "item_sys_id.$": "$.catalog_items.result[0].sys_id",
        "sysparm_quantity": "1"
      },
      "ResultPath": "$.order",
      "Next": "GetRequest"
    },
    "GetRequest": {
      "Type": "Task",
      "Resource": "servicenow://service_catalog/get_request",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "request_id.$": "$.order.result.request_id"
      },
      "ResultPath": "$.request_detail",
      "End": true
    }
  }
}
