# Floe::ServiceNow

ServiceNow API integration for [Floe](https://github.com/ManageIQ/floe) workflow engine. This gem provides a Runner and Methods classes that inherit from `Floe::BuiltinRunner::Runner` and `Floe::BuiltinRunner::Methods` to enable ServiceNow operations within Floe workflows.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'floe-servicenow'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install floe-servicenow
```

## Features
- **ServiceNow Table API**: Manage ServiceNow Tables
- **ServiceNow CMDB API**: Manage Configuration Items and relationships
- **ServiceNow Incident API**: Create, update, resolve, and query incidents
- **ServiceNow Service Catalog API**: Browse catalogs, manage cart, and submit orders

## Configuration

### Secrets

ServiceNow operations require authentication credentials passed via the `secrets` parameter:

```json
{
  "username": "your-username",
  "password": "your-password"
}
```

**Security Note**: Never hardcode credentials in your workflow definitions. Use Floe's secrets management features.

## Usage

### Resource URI Format

ServiceNow operations use the `servicenow://` URI scheme with API prefix:

```
servicenow://<api_name>/<method_name>
```

For example:
- `servicenow://table/list_tables` - List all tables using Table API

### Example Workflows

Complete workflow examples demonstrating API usage can be found in the `examples/` directory:

- **`examples/table.asl`** - Demonstrates all Table API CRUD operations in a single workflow
- **`examples/cmdb.asl`** - Demonstrates CMDB API operations including CI management and relationships
- **`examples/incident.asl`** - Demonstrates Incident API operations (create, resolve, close)
- **`examples/service_catalog.asl`** - Demonstrates Service Catalog API operations (browse catalogs, order items, track requests)

### Available Methods

#### Table API Methods

##### 1. List Tables

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

##### 2. Query Records

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

##### 3. Get Record

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

##### 4. Create Record

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

##### 5. Update Record

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

##### 6. Patch Record

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

##### 7. Delete Record

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

#### CMDB API Methods

##### 1. Get Configuration Item

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

##### 2. Query Configuration Items

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

##### 3. Create Configuration Item

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

##### 4. Update Configuration Item

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

##### 5. Delete Configuration Item

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

##### 6. Get CI Relationships

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

##### 7. Create CI Relationship

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

##### 8. Get CI Classes

Retrieve available CMDB CI classes (types).

**Resource**: `servicenow://cmdb/get_ci_classes`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier



#### Incident API Methods

##### 1. Create Incident

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

##### 2. Get Incident

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

##### 3. Update Incident

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

##### 4. Resolve Incident

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

##### 5. Close Incident

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

##### 6. Query Incidents

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

#### Service Catalog API Methods

##### 1. Submit Catalog Item

Submit a catalog item order directly without using the cart.

**Resource**: `servicenow://service_catalog/submit_catalog_item`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `item_sys_id` (string): sys_id of the catalog item to order

**Optional Parameters**:
- `variables` (object): Hash of variable names and values for the catalog item
- Additional parameters as needed by the catalog item

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/submit_catalog_item",
  "Parameters": {
    "instance_id": "dev12345",
    "item_sys_id": "abc123",
    "variables": {
      "quantity": "1",
      "requested_for": "user@example.com"
    }
  }
}
```

##### 2. Get Request

Retrieve details of a service catalog request.

**Resource**: `servicenow://service_catalog/get_request`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `request_id` (string): sys_id of the request

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_request",
  "Parameters": {
    "instance_id": "dev12345",
    "request_id": "req123"
  }
}
```

##### 3. Get Requested Item

Retrieve summary of a requested catalog item.

**Resource**: `servicenow://service_catalog/get_requested_item`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `requested_item_id` (string): sys_id of the requested item

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_requested_item",
  "Parameters": {
    "instance_id": "dev12345",
    "requested_item_id": "ritm123"
  }
}
```

##### 4. Get Catalogs

Retrieve all available service catalogs.

**Resource**: `servicenow://service_catalog/get_catalogs`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_catalogs",
  "Parameters": {
    "instance_id": "dev12345"
  }
}
```

##### 5. Get Catalog

Retrieve details of a specific service catalog.

**Resource**: `servicenow://service_catalog/get_catalog`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `catalog_id` (string): sys_id of the catalog

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_catalog",
  "Parameters": {
    "instance_id": "dev12345",
    "catalog_id": "cat123"
  }
}
```

##### 6. Get Categories

Retrieve all available catalog categories.

**Resource**: `servicenow://service_catalog/get_categories`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_categories",
  "Parameters": {
    "instance_id": "dev12345"
  }
}
```

##### 7. Get Category

Retrieve details of a specific catalog category.

**Resource**: `servicenow://service_catalog/get_category`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `category_id` (string): sys_id of the category

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_category",
  "Parameters": {
    "instance_id": "dev12345",
    "category_id": "category123"
  }
}
```

##### 8. Get Items

Retrieve all available catalog items.

**Resource**: `servicenow://service_catalog/get_items`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_items",
  "Parameters": {
    "instance_id": "dev12345"
  }
}
```

##### 9. Get Item

Retrieve details of a specific catalog item.

**Resource**: `servicenow://service_catalog/get_item`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `item_id` (string): sys_id of the catalog item

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_item",
  "Parameters": {
    "instance_id": "dev12345",
    "item_id": "item123"
  }
}
```

##### 10. Search Items

Search for catalog items by search term.

**Resource**: `servicenow://service_catalog/search_items`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `search_term` (string): Search term to find items

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/search_items",
  "Parameters": {
    "instance_id": "dev12345",
    "search_term": "laptop"
  }
}
```

##### 11. Get Cart

Retrieve the current shopping cart contents.

**Resource**: `servicenow://service_catalog/get_cart`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/get_cart",
  "Parameters": {
    "instance_id": "dev12345"
  }
}
```

##### 12. Add to Cart

Add a catalog item to the shopping cart.

**Resource**: `servicenow://service_catalog/add_to_cart`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `item_id` (string): sys_id of the catalog item to add

**Optional Parameters**:
- `cart_id` (string): sys_id of the cart (defaults to "default")
- `quantity` (integer): Quantity to add
- `variables` (object): Hash of variable names and values

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/add_to_cart",
  "Parameters": {
    "instance_id": "dev12345",
    "item_id": "item123",
    "quantity": 2,
    "variables": {
      "color": "black",
      "size": "15-inch"
    }
  }
}
```

##### 13. Update Cart Item

Update a catalog item in the shopping cart.

**Resource**: `servicenow://service_catalog/update_cart_item`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `cart_item_id` (string): sys_id of the cart item to update

**Optional Parameters**:
- `cart_id` (string): sys_id of the cart (defaults to "default")
- `quantity` (integer): New quantity
- `variables` (object): Updated variable values

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/update_cart_item",
  "Parameters": {
    "instance_id": "dev12345",
    "cart_item_id": "cartitem123",
    "quantity": 3
  }
}
```

##### 14. Remove from Cart

Remove a catalog item from the shopping cart.

**Resource**: `servicenow://service_catalog/remove_from_cart`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier
- `cart_item_id` (string): sys_id of the cart item to remove

**Optional Parameters**:
- `cart_id` (string): sys_id of the cart (defaults to "default")

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/remove_from_cart",
  "Parameters": {
    "instance_id": "dev12345",
    "cart_item_id": "cartitem123"
  }
}
```

##### 15. Empty Cart

Remove all items from the shopping cart.

**Resource**: `servicenow://service_catalog/empty_cart`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Optional Parameters**:
- `cart_id` (string): sys_id of the cart (defaults to "default")

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/empty_cart",
  "Parameters": {
    "instance_id": "dev12345"
  }
}
```

##### 16. Checkout Cart

Checkout the shopping cart (prepare for order submission).

**Resource**: `servicenow://service_catalog/checkout_cart`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Optional Parameters**:
- `cart_id` (string): sys_id of the cart
- `special_instructions` (string): Special instructions for the order

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/checkout_cart",
  "Parameters": {
    "instance_id": "dev12345",
    "special_instructions": "Please deliver to building A"
  }
}
```

##### 17. Submit Order

Submit the shopping cart as an order.

**Resource**: `servicenow://service_catalog/submit_order`

**Required Parameters**:
- `instance_id` (string): ServiceNow instance identifier

**Optional Parameters**:
- `cart_id` (string): sys_id of the cart
- `requested_for` (string): sys_id of the user the order is for

**Example**:

```json
{
  "Resource": "servicenow://service_catalog/submit_order",
  "Parameters": {
    "instance_id": "dev12345",
    "requested_for": "user123"
  }
}
```

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ManageIQ/floe-servicenow.

### Development Guidelines

1. Follow existing code patterns from `Floe::BuiltinRunner`
2. Add tests for all new methods
3. Update documentation for new features
4. Ensure all tests pass before submitting PR

## License

The gem is available as open source under the terms of the [Apache-2.0 License](https://opensource.org/licenses/Apache-2.0).

## Related Projects

- [Floe](https://github.com/ManageIQ/floe) - Workflow engine for Ruby
- [ManageIQ](https://github.com/ManageIQ/manageiq) - Open-source management platform

## Support

For issues and questions:
- GitHub Issues: https://github.com/ManageIQ/floe-servicenow/issues
- ManageIQ Community: https://www.manageiq.org/community/
