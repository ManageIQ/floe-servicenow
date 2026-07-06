{
  "Comment": "Example of OAuth refresh token grant flow followed by authenticated API call",
  "StartAt": "OauthToken",
  "States": {
    "OauthToken": {
      "Type": "Task",
      "Resource": "servicenow://oauth/token",
      "Credentials": {
        "client_secret.$": "$$.Credentials.client_secret",
        "refresh_token.$": "$$.Credentials.refresh_token"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "client_id.$": "$.client_id",
        "grant_type": "refresh_token",
        "scope": "useraccount"
      },
      "ResultPath": "$$.Credentials.oauth_token",
      "Next": "GetCIClasses"
    },
    "GetCIClasses": {
      "Type": "Task",
      "Resource": "servicenow://cmdb/get_ci_classes",
      "Credentials": {
        "access_token.$": "$$.Credentials.oauth_token.access_token"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "limit": 5
      },
      "ResultPath": "$.ci_classes",
      "End": true
    }
  }
}
