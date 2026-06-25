{
  "Comment": "ServiceNow CMDB API Examples - Demonstrates Configuration Item management and relationships",
  "StartAt": "GetCIClasses",
  "States": {
    "GetCIClasses": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/get_ci_classes",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "limit": 5
      },
      "ResultPath": "$.ci_classes",
      "Next": "QueryCIs"
    },
    "QueryCIs": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/query_cis",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "method": "GET",
        "table": "cmdb_ci_server",
        "limit": 1,
        "fields": "sys_id,name,ip_address,os"
      },
      "ResultPath": "$.servers",
      "Next": "CreateCI"
    },
    "CreateCI": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/create_ci",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table": "cmdb_ci_server",
        "name": "test-server-workflow",
        "ip_address": "192.168.100.50",
        "os": "Ubuntu 22.04",
        "operational_status": "1"
      },
      "ResultPath": "$.new_ci",
      "Next": "UpdateCI"
    },
    "UpdateCI": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/update_ci",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "sys_id.$": "$.new_ci.result.sys_id",
        "table": "cmdb_ci_server",
        "ip_address": "192.168.100.51",
        "comments": "Updated by workflow"
      },
      "ResultPath": "$.updated_ci",
      "Next": "DeleteCI"
    },
    "DeleteCI": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/delete_ci",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "sys_id.$": "$.new_ci.result.sys_id",
        "table": "cmdb_ci_server"
      },
      "ResultPath": "$.delete_result",
      "Next": "Success"
    },
    "Success": {
      "Type": "Succeed"
    }
  }
}
