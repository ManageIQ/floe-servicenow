{
  "Comment": "Example of getting an access token with a client_id/secret/refresh_token",
  "StartAt": "OauthRefreshToken",
  "States": {
    "OauthRefreshToken": {
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
      "End": true
    }
  }
}
