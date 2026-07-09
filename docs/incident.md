# Incident API Methods

## Table of Contents

| Method | Description |
|--------|-------------|
| [Create Incident](#create-incident) | Create a new incident |
| [Get Incident](#get-incident) | Retrieve a single incident by sys_id |
| [Update Incident](#update-incident) | Update an existing incident |
| [Resolve Incident](#resolve-incident) | Resolve an incident (state 6) |
| [Close Incident](#close-incident) | Close an incident (state 7) |
| [Query Incidents](#query-incidents) | Query multiple incidents with filtering |

## Create Incident

Create a new incident in ServiceNow.

**Resource**: `servicenow://incident/create_incident`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `short_description` (string): Brief description of the incident

**Optional Parameters**:
- `urgency` (string): Urgency level (1=High, 2=Medium, 3=Low)
- `impact` (string): Impact level (1=High, 2=Medium, 3=Low)
- `priority` (string): Priority (calculated from urgency and impact)
- `assignment_group` (string): sys_id of the assignment group
- `assigned_to` (string): sys_id of the assigned user
- `caller_id` (string): sys_id of the caller
- `category` (string): Incident category
- `subcategory` (string): Incident subcategory
- Additional incident fields as key-value pairs

**Example**:

```json
{
  "Resource": "servicenow://incident/create_incident",
  "Parameters": {
    "instance_id": "dev12345",
    "short_description": "Network connectivity issue",
    "urgency": "2",
    "impact": "2",
    "category": "Network"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123",
    "number": "INC0010001",
    "short_description": "Network connectivity issue",
    "urgency": "2",
    "impact": "2",
    "state": "1"
  }
}
```

## Get Incident

Retrieve a single incident by its sys_id.

**Resource**: `servicenow://incident/get_incident`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the incident

**Example**:

```json
{
  "Resource": "servicenow://incident/get_incident",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "number": "INC0010001",
    "short_description": "Network connectivity issue",
    "state": "2",
    "priority": "3"
  }
}
```

## Update Incident

Update an existing incident.

**Resource**: `servicenow://incident/update_incident`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the incident

**Optional Parameters**:
- Any incident field as key-value pairs to update

**Example**:

```json
{
  "Resource": "servicenow://incident/update_incident",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456",
    "state": "2",
    "work_notes": "Investigating the issue"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "number": "INC0010001",
    "state": "2",
    "work_notes": "Investigating the issue"
  }
}
```

## Resolve Incident

Resolve an incident (sets state to 6 - Resolved).

**Resource**: `servicenow://incident/resolve_incident`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the incident

**Optional Parameters**:
- `close_notes` (string): Resolution notes
- `close_code` (string): Resolution code
- Any other incident fields to update

**Example**:

```json
{
  "Resource": "servicenow://incident/resolve_incident",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456",
    "close_notes": "Issue resolved by restarting the service",
    "close_code": "Solved (Permanently)"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "number": "INC0010001",
    "state": "6",
    "close_notes": "Issue resolved by restarting the service"
  }
}
```

## Close Incident

Close an incident (sets state to 7 - Closed).

**Resource**: `servicenow://incident/close_incident`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the incident

**Optional Parameters**:
- `close_notes` (string): Closure notes
- `close_code` (string): Closure code
- Any other incident fields to update

**Example**:

```json
{
  "Resource": "servicenow://incident/close_incident",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456",
    "close_notes": "Incident closed after verification",
    "close_code": "Closed/Resolved by Caller"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "number": "INC0010001",
    "state": "7",
    "close_notes": "Incident closed after verification"
  }
}
```

## Query Incidents

Query multiple incidents with optional filtering.

**Resource**: `servicenow://incident/query_incidents`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Optional Parameters**:
- `query` (string): Encoded query string (e.g., "active=true^priority=1")
- `limit` (integer): Maximum number of records to return
- `offset` (integer): Starting record index for pagination
- `fields` (string): Comma-separated list of fields to return

**Example**:

```json
{
  "Resource": "servicenow://incident/query_incidents",
  "Parameters": {
    "instance_id": "dev12345",
    "query": "active=true^priority=1",
    "limit": 1,
    "fields": "number,short_description,state,priority"
  }
}
```

**Response**:

```json
{
  "result": [
    {
      "result": {
        "sys_id": "abc123def456",
        "number": "INC0010001",
        "short_description": "Network connectivity issue",
        "state": "2",
        "priority": "3"
      }
    }
  ]
}
```
