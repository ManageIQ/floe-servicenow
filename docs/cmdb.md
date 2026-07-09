# CMDB API Methods

## Table of Contents

| Method | Description |
|--------|-------------|
| [Get Configuration Item](#get-configuration-item) | Retrieve a single CI by sys_id |
| [Query Configuration Items](#query-configuration-items) | Query multiple CIs with filtering |
| [Create Configuration Item](#create-configuration-item) | Create a new CI |
| [Update Configuration Item](#update-configuration-item) | Update an existing CI |
| [Delete Configuration Item](#delete-configuration-item) | Delete a CI |
| [Get CI Relationships](#get-ci-relationships) | Retrieve CI and its relationships |
| [Create CI Relationship](#create-ci-relationship) | Create a relationship between two CIs |
| [Get CI Classes](#get-ci-classes) | Retrieve available CMDB CI classes |

## Get Configuration Item

Retrieve a single Configuration Item (CI) by its sys_id.

**Resource**: `servicenow://cmdb/get_ci`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the CI

**Optional Parameters**:
- `table` (string): CMDB table name (defaults to "cmdb_ci")

**Example**:

```json
{
  "Resource": "servicenow://cmdb/get_ci",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456",
    "table": "cmdb_ci_server"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "name": "web-server-01",
    "ip_address": "192.168.1.100"
  }
}
```

## Query Configuration Items

Query multiple Configuration Items with optional filtering.

**Resource**: `servicenow://cmdb/query_cis`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `method` (string): HTTP method (typically "GET")

**Optional Parameters**:
- `table` (string): CMDB table name (defaults to "cmdb_ci")
- `query` (string): Encoded query string
- `limit` (integer): Maximum number of records to return
- `offset` (integer): Starting record index for pagination
- `fields` (string): Comma-separated list of fields to return

**Example**:

```json
{
  "Resource": "servicenow://cmdb/query_cis",
  "Parameters": {
    "instance_id": "dev12345",
    "method": "GET",
    "table": "cmdb_ci_server",
    "query": "operational_status=1",
    "limit": 10,
    "fields": "name,ip_address,os"
  }
}
```

**Response**:

```json
{
  "result": [
    {
      "name": "web-server-01",
      "ip_address": "192.168.1.100",
      "os": "Linux"
    }
  ]
}
```

## Create Configuration Item

Create a new Configuration Item.

**Resource**: `servicenow://cmdb/create_ci`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Optional Parameters**:
- `table` (string): CMDB table name (defaults to "cmdb_ci")
- Additional fields as key-value pairs for the CI

**Example**:

```json
{
  "Resource": "servicenow://cmdb/create_ci",
  "Parameters": {
    "instance_id": "dev12345",
    "table": "cmdb_ci_server",
    "name": "new-server-01",
    "ip_address": "192.168.1.200",
    "os": "Ubuntu 20.04"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "xyz789",
    "name": "new-server-01",
    "ip_address": "192.168.1.200",
    "os": "Ubuntu 20.04"
  }
}
```

## Update Configuration Item

Update an existing Configuration Item.

**Resource**: `servicenow://cmdb/update_ci`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the CI to update

**Optional Parameters**:
- `table` (string): CMDB table name (defaults to "cmdb_ci")
- Additional fields as key-value pairs to update

**Example**:

```json
{
  "Resource": "servicenow://cmdb/update_ci",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456",
    "table": "cmdb_ci_server",
    "ip_address": "192.168.1.150",
    "operational_status": "1"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "name": "web-server-01",
    "ip_address": "192.168.1.150",
    "operational_status": "1"
  }
}
```

## Delete Configuration Item

Delete a Configuration Item.

**Resource**: `servicenow://cmdb/delete_ci`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the CI to delete

**Optional Parameters**:
- `table` (string): CMDB table name (defaults to "cmdb_ci")

**Example**:

```json
{
  "Resource": "servicenow://cmdb/delete_ci",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456",
    "table": "cmdb_ci_server"
  }
}
```

**Response**:

```json
{
  "result": {
    "success": true
  }
}
```

## Get CI Relationships

Retrieve a Configuration Item and its relationships.

**Resource**: `servicenow://cmdb/get_ci_relationships`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `sys_id` (string): Unique identifier of the CI

**Example**:

```json
{
  "Resource": "servicenow://cmdb/get_ci_relationships",
  "Parameters": {
    "instance_id": "dev12345",
    "sys_id": "abc123def456"
  }
}
```

**Response**:

```json
{
  "sys_id": "abc123def456",
  "name": "web-server-01",
  "relationships": [
    {
      "parent": "abc123def456",
      "child": "xyz789",
      "type": "Depends on::Used by"
    }
  ]
}
```

## Create CI Relationship

Create a relationship between two Configuration Items.

**Resource**: `servicenow://cmdb/create_ci_relationship`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `parent_sys_id` (string): sys_id of the parent CI
- `child_sys_id` (string): sys_id of the child CI
- `relationship_type` (string): Type of relationship (e.g., "Depends on::Used by")

**Optional Parameters**:
- `connection_strength` (string): Strength of the connection (defaults to "1")

**Example**:

```json
{
  "Resource": "servicenow://cmdb/create_ci_relationship",
  "Parameters": {
    "instance_id": "dev12345",
    "parent_sys_id": "abc123",
    "child_sys_id": "xyz789",
    "relationship_type": "Depends on::Used by",
    "connection_strength": "2"
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "rel123",
    "parent": "abc123",
    "child": "xyz789",
    "type": "Depends on::Used by",
    "connection_strength": "2"
  }
}
```

## Get CI Classes

Retrieve available CMDB CI classes (types).

**Resource**: `servicenow://cmdb/get_ci_classes`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Optional Parameters**:
- `limit` (integer): Maximum number of classes to return

**Example**:

```json
{
  "Resource": "servicenow://cmdb/get_ci_classes",
  "Parameters": {
    "instance_id": "dev12345",
    "limit": 5
  }
}
```

**Response**:

```json
{
  "result": [
    {
      "name": "cmdb_ci_server",
      "label": "Server",
      "super_class": "cmdb_ci_computer"
    },
    {
      "name": "cmdb_ci_computer",
      "label": "Computer",
      "super_class": "cmdb_ci_hardware"
    }
  ]
}
```
