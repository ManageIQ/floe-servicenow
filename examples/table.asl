{
  "Comment": "ServiceNow Table API Examples - Demonstrates all CRUD operations",
  "StartAt": "ListTables",
  "States": {
    "ListTables": {
      "Type": "Task",
      "Resource": "servicenow://table/list_tables",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "query": "nameSTARTSWITHcmdb",
        "limit": 5,
        "fields": "name,label"
      },
      "ResultPath": "$.tables",
      "Next": "QueryRecords"
    },
    "QueryRecords": {
      "Type": "Task",
      "Resource": "servicenow://table/query_records",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table_name": "incident",
        "query": "active=true^priority=1",
        "limit": 10,
        "fields": "sys_id,number,short_description,state,priority",
        "display_value": "true"
      },
      "ResultPath": "$.incidents",
      "Next": "GetRecord"
    },
    "GetRecord": {
      "Type": "Task",
      "Resource": "servicenow://table/get_record",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table_name": "incident",
        "sys_id.$": "$.incidents.result[0].sys_id",
        "fields": "number,short_description,state,priority,assigned_to",
        "display_value": "all"
      },
      "ResultPath": "$.incident_detail",
      "Next": "CreateRecord"
    },
    "CreateRecord": {
      "Type": "Task",
      "Resource": "servicenow://table/create_record",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table_name": "incident",
        "data": {
          "short_description": "Test incident created by workflow",
          "urgency": "3",
          "impact": "3",
          "category": "Software",
          "subcategory": "Email"
        },
        "display_value": "true"
      },
      "ResultPath": "$.new_incident",
      "Next": "PatchRecord"
    },
    "PatchRecord": {
      "Type": "Task",
      "Resource": "servicenow://table/patch_record",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table_name": "incident",
        "sys_id.$": "$.new_incident.result.sys_id",
        "data": {
          "state": "2",
          "work_notes": "Updated by workflow - investigating issue"
        },
        "display_value": "true"
      },
      "ResultPath": "$.patched_incident",
      "Next": "UpdateRecord"
    },
    "UpdateRecord": {
      "Type": "Task",
      "Resource": "servicenow://table/update_record",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table_name": "incident",
        "sys_id.$": "$.new_incident.result.sys_id",
        "data": {
          "short_description": "Test incident - UPDATED",
          "urgency": "3",
          "impact": "3"
        },
        "display_value": "true"
      },
      "ResultPath": "$.updated_incident",
      "Next": "DeleteRecord"
    },
    "DeleteRecord": {
      "Type": "Task",
      "Resource": "servicenow://table/delete_record",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "table_name": "incident",
        "sys_id.$": "$.new_incident.result.sys_id"
      },
      "ResultPath": "$.delete_result",
      "Next": "Success"
    },
    "Success": {
      "Type": "Succeed"
    }
  }
}
