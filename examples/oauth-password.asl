{
  "Comment": "Example of getting an access token",
  "StartAt": "OauthToken",
  "States": {
    "OauthToken": {
      "Type": "Task",
      "Resource": "servicenow://oauth/token",
      "Credentials": {
        "client_secret.$": "$$.Credentials.client_secret",
        "username.$": "$$.Credentials.username",
        "password.$": "$$.Credentials.password"
      },
      "Parameters": {
        "instance_id.$": "$.instance_id",
        "client_id.$": "$.client_id",
        "grant_type": "password"
      },
      "ResultPath": "$$.Credentials.oauth_token",
      "End": true
    }
  }
}
