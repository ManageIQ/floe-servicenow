# Table API Methods

## Table of Contents

| Method | Description |
|--------|-------------|
| [List Tables](#list-tables) | List all sys_db_object tables |
| [Query Records](#query-records) | Retrieve multiple records with filtering |
| [Get Record](#get-record) | Retrieve a single record by sys_id |
| [Create Record](#create-record) | Create a new record in a table |
| [Update Record](#update-record) | Replace all fields of a record (PUT) |
| [Patch Record](#patch-record) | Update specific fields of a record (PATCH) |
| [Delete Record](#delete-record) | Delete a record from a table |

## List Tables

Lists all `sys_db_object` tables.

**Resource**: `servicenow://table/list_tables`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier used to build `https://#{instance_id}.service-now.com`

**Optional Parameters**:
- `query` (string): Query parameters e.g.: `active=true`
- `limit` (integer): Maximum number of records to return
- `offset` (integer): Starting record index for which to begin retrieving records. Use this value to paginate record retrieval.
- `fields` (string): Comma-separated list of fields to return in the response.

**Example**:

```json
{
  "Resource": "servicenow://table/list_tables",
  "Parameters": {
    "instance_id": "dev12345",
    "query": "active=true",
    "limit": 2
  }
}
```

**Response**:

```json
{
  "result": [
    {
      "name": "sn_mif_sync_data"
    },
    {
      "name": "open_nlu_predict_log0000"
    }
  ]
}
```

## Query Records

Retrieve multiple records from a specific table with optional filtering.

**Resource**: `servicenow://table/query_records`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `table_name` (string): Name of the table to query (e.g., "incident", "cmdb_ci")

**Optional Parameters**:
- `query` (string): Encoded query string (e.g., "active=true^priority=1")
- `limit` (integer): Maximum number of records to return
- `offset` (integer): Starting record index for pagination
- `fields` (string): Comma-separated list of fields to return
- `display_value` (string): Return display values ("true", "false", or "all")
- `exclude_reference_link` (boolean): Exclude reference links from response

**Example**:

```json
{
  "Resource": "servicenow://table/query_records",
  "Parameters": {
    "instance_id": "dev12345",
    "table_name": "incident",
    "query": "active=true^priority=1",
    "limit": 10,
    "fields": "number,short_description,priority"
  }
}
```

**Response**:

```json
{
  "result": [
    {
      "number": "INC0001",
      "short_description": "Network connectivity issue",
      "priority": "1"
    }
  ]
}
```

## Get Record

Retrieve a single record by its sys_id.

**Resource**: `servicenow://table/get_record`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `table_name` (string): Name of the table
- `sys_id` (string): Unique identifier of the record

**Optional Parameters**:
- `fields` (string): Comma-separated list of fields to return
- `display_value` (string): Return display values ("true", "false", or "all")
- `exclude_reference_link` (boolean): Exclude reference links from response

**Example**:

```json
{
  "Resource": "servicenow://table/get_record",
  "Parameters": {
    "instance_id": "dev12345",
    "table_name": "incident",
    "sys_id": "abc123def456",
    "fields": "number,short_description,state"
  }
}
```

**Response**:

```json
{
  "result": {
    "number": "INC0001",
    "short_description": "Network connectivity issue",
    "state": "2"
  }
}
```

## Create Record

Create a new record in a table.

**Resource**: `servicenow://table/create_record`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `table_name` (string): Name of the table
- `data` (object): Hash of field names and values for the new record

**Optional Parameters**:
- `display_value` (string): Return display values ("true", "false", or "all")
- `exclude_reference_link` (boolean): Exclude reference links from response
- `input_display_value` (boolean): Set field values using display values

**Example**:

```json
{
  "Resource": "servicenow://table/create_record",
  "Parameters": {
    "instance_id": "dev12345",
    "table_name": "incident",
    "data": {
      "short_description": "New network issue",
      "urgency": "2",
      "impact": "2"
    }
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "xyz789",
    "number": "INC0010",
    "short_description": "New network issue",
    "urgency": "2",
    "impact": "2"
  }
}
```

## Update Record

Replace all fields of an existing record (PUT operation).

**Resource**: `servicenow://table/update_record`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `table_name` (string): Name of the table
- `sys_id` (string): Unique identifier of the record
- `data` (object): Hash of field names and values (replaces entire record)

**Optional Parameters**:
- `display_value` (string): Return display values ("true", "false", or "all")
- `exclude_reference_link` (boolean): Exclude reference links from response
- `input_display_value` (boolean): Set field values using display values

**Example**:

```json
{
  "Resource": "servicenow://table/update_record",
  "Parameters": {
    "instance_id": "dev12345",
    "table_name": "incident",
    "sys_id": "abc123def456",
    "data": {
      "short_description": "Updated description",
      "state": "3",
      "priority": "2"
    }
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "number": "INC0001",
    "short_description": "Updated description",
    "state": "3",
    "priority": "2"
  }
}
```

## Patch Record

Update specific fields of an existing record (PATCH operation).

**Resource**: `servicenow://table/patch_record`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `table_name` (string): Name of the table
- `sys_id` (string): Unique identifier of the record
- `data` (object): Hash of field names and values to update

**Optional Parameters**:
- `display_value` (string): Return display values ("true", "false", or "all")
- `exclude_reference_link` (boolean): Exclude reference links from response
- `input_display_value` (boolean): Set field values using display values

**Example**:

```json
{
  "Resource": "servicenow://table/patch_record",
  "Parameters": {
    "instance_id": "dev12345",
    "table_name": "incident",
    "sys_id": "abc123def456",
    "data": {
      "state": "6"
    }
  }
}
```

**Response**:

```json
{
  "result": {
    "sys_id": "abc123def456",
    "number": "INC0001",
    "state": "6"
  }
}
```

## Delete Record

Delete a record from a table.

**Resource**: `servicenow://table/delete_record`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `table_name` (string): Name of the table
- `sys_id` (string): Unique identifier of the record to delete

**Example**:

```json
{
  "Resource": "servicenow://table/delete_record",
  "Parameters": {
    "instance_id": "dev12345",
    "table_name": "incident",
    "sys_id": "abc123def456"
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
