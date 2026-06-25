{
  "Comment": "Example create, resolve, and close a ServiceNow Incident",
  "StartAt": "CreateIncident",
  "States": {
    "CreateIncident": {
      "Type": "Task",
      "Resource": "servicenow://incident/create_incident",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "short_description": "Test incident created by workflow",
        "urgency": "3",
        "impact": "3"
      },
      "ResultPath": "$.incident",
      "Next": "ResolveIncident"
    },
    "ResolveIncident": {
      "Type": "Task",
      "Resource": "servicenow://incident/resolve_incident",
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "sys_id.$": "$.incident.result.sys_id",
        "close_notes": "Issue resolved by workflow",
        "close_code": "Solution provided"
      },
      "ResultPath": "$.resolved_incident",
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Next": "CloseIncident"
    },
    "CloseIncident": {
      "Type": "Task",
      "Resource": "servicenow://incident/close_incident",
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "sys_id.$": "$.incident.result.sys_id",
        "close_notes": "Incident closed by workflow",
        "close_code": "Solution provided"
      },
      "Credentials": {
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "End": true
    }
  }
}
