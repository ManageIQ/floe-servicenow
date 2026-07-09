# OAuth API Methods

## Table of Contents

| Method | Description |
|--------|-------------|
| [Get OAuth Token](#get-oauth-token) | Obtain OAuth access tokens using password or refresh_token grant types |

## Get OAuth Token

Obtain an OAuth access token using various grant types.

**Resource**: `servicenow://oauth/token`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `grant_type` (string): OAuth grant type ("password" or "refresh_token")
- `client_id` (string): OAuth client ID

**Required Credentials** (varies by grant type):

**Password Grant**:
- `client_secret` (string): OAuth client secret
- `username` (string): ServiceNow username
- `password` (string): ServiceNow password

**Refresh Token Grant**:
- `client_secret` (string): OAuth client secret
- `refresh_token` (string): Valid refresh token

**Example - Password Grant**:

```json
{
  "Resource": "servicenow://oauth/token",
  "Credentials": {
    "client_secret.$": "$$.Credentials.client_secret",
    "username.$": "$$.Credentials.username",
    "password.$": "$$.Credentials.password"
  },
  "Parameters": {
    "instance_id": "dev12345",
    "client_id": "your-client-id",
    "grant_type": "password"
  },
  "ResultPath": "$$.Credentials.oauth_token"
}
```

**Example - Refresh Token Grant**:

```json
{
  "Resource": "servicenow://oauth/token",
  "Credentials": {
    "client_secret.$": "$$.Credentials.client_secret",
    "refresh_token.$": "$$.Credentials.refresh_token"
  },
  "Parameters": {
    "instance_id": "dev12345",
    "client_id": "your-client-id",
    "grant_type": "refresh_token"
  },
  "ResultPath": "$$.Credentials.oauth_token"
}
```

**Response**:

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "refresh_token_value",
  "scope": "useraccount",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

**Using the Access Token**:

After obtaining an access token, use it in subsequent API calls:

```json
{
  "Resource": "servicenow://cmdb/get_ci_classes",
  "Credentials": {
    "access_token.$": "$$.Credentials.oauth_token.access_token"
  },
  "Parameters": {
    "instance_id": "dev12345",
    "limit": 5
  }
}
```

**Complete Workflow Example**:
- `examples/oauth.asl` - Combined OAuth flow supporting both password and refresh_token grant types with authenticated API call
