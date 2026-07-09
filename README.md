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

## API Classes
- **[ServiceNow CMDB API](#cmdb-api-methods)**: Manage Configuration Items and relationships
- **[ServiceNow Incident API](#incident-api-methods)**: Create, update, resolve, and query incidents
- **[ServiceNow OAuth API](#oauth-api-methods)**: Authenticate and get an API token
- **[ServiceNow Service Catalog API](#service-catalog-api-methods)**: Browse catalogs, manage cart, and submit orders
- **[ServiceNow Table API](#table-api-methods)**: Manage ServiceNow Tables

## Configuration

### Authentication

ServiceNow operations support two authentication methods:

#### Basic Authentication
```json
{
  "username": "your-username",
  "password": "your-password"
}
```

#### OAuth Bearer Token
```json
{
  "access_token": "your-oauth-access-token",
  "client_id": "your-client-id",
  "client_secret": "your-client-secret",
  "refresh_token": "your-refresh-token"
}
```

**Security Note**: Never hardcode credentials in your workflow definitions. Use Floe's secrets management features.

### OAuth Token Acquisition

Use the `servicenow://oauth/token` endpoint to obtain OAuth access tokens. See the [OAuth API Methods](#oauth-api-methods) section for details.

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

- **`examples/cmdb.asl`** - Demonstrates CMDB API operations including CI management and relationships
- **`examples/incident.asl`** - Demonstrates Incident API operations (create, resolve, close)
- **`examples/oauth.asl`** - Demonstrates OAuth authentication with both password and refresh_token grant types
- **`examples/service_catalog.asl`** - Demonstrates Service Catalog API operations (browse catalogs, order items, track requests)
- **`examples/table.asl`** - Demonstrates all Table API CRUD operations in a single workflow

### Available Methods

#### OAuth API Methods

See [OAuth API documentation](docs/oauth.md) for authentication methods.

| Method | Description |
|--------|-------------|
| [Get OAuth Token](docs/oauth.md#get-oauth-token) | Obtain OAuth access tokens using password or refresh_token grant types |

#### Table API Methods

See [Table API documentation](docs/table.md) for CRUD operations on ServiceNow tables.

| Method | Description |
|--------|-------------|
| [List Tables](docs/table.md#list-tables) | List all sys_db_object tables |
| [Query Records](docs/table.md#query-records) | Retrieve multiple records with filtering |
| [Get Record](docs/table.md#get-record) | Retrieve a single record by sys_id |
| [Create Record](docs/table.md#create-record) | Create a new record in a table |
| [Update Record](docs/table.md#update-record) | Replace all fields of a record (PUT) |
| [Patch Record](docs/table.md#patch-record) | Update specific fields of a record (PATCH) |
| [Delete Record](docs/table.md#delete-record) | Delete a record from a table |

#### CMDB API Methods

See [CMDB API documentation](docs/cmdb.md) for Configuration Management Database operations.

| Method | Description |
|--------|-------------|
| [Get Configuration Item](docs/cmdb.md#get-configuration-item) | Retrieve a single CI by sys_id |
| [Query Configuration Items](docs/cmdb.md#query-configuration-items) | Query multiple CIs with filtering |
| [Create Configuration Item](docs/cmdb.md#create-configuration-item) | Create a new CI |
| [Update Configuration Item](docs/cmdb.md#update-configuration-item) | Update an existing CI |
| [Delete Configuration Item](docs/cmdb.md#delete-configuration-item) | Delete a CI |
| [Get CI Relationships](docs/cmdb.md#get-ci-relationships) | Retrieve CI and its relationships |
| [Create CI Relationship](docs/cmdb.md#create-ci-relationship) | Create a relationship between two CIs |
| [Get CI Classes](docs/cmdb.md#get-ci-classes) | Retrieve available CMDB CI classes |

#### Incident API Methods

See [Incident API documentation](docs/incident.md) for incident management operations.

| Method | Description |
|--------|-------------|
| [Create Incident](docs/incident.md#create-incident) | Create a new incident |
| [Get Incident](docs/incident.md#get-incident) | Retrieve a single incident by sys_id |
| [Update Incident](docs/incident.md#update-incident) | Update an existing incident |
| [Resolve Incident](docs/incident.md#resolve-incident) | Resolve an incident (state 6) |
| [Close Incident](docs/incident.md#close-incident) | Close an incident (state 7) |
| [Query Incidents](docs/incident.md#query-incidents) | Query multiple incidents with filtering |

#### Service Catalog API Methods

See [Service Catalog API documentation](docs/service_catalog.md) for catalog browsing and ordering operations.

| Method | Description |
|--------|-------------|
| [Submit Catalog Item](docs/service_catalog.md#submit-catalog-item) | Submit a catalog item order directly |
| [Get Request](docs/service_catalog.md#get-request) | Retrieve details of a service catalog request |
| [Get Requested Item](docs/service_catalog.md#get-requested-item) | Retrieve summary of a requested catalog item |
| [Get Catalogs](docs/service_catalog.md#get-catalogs) | Retrieve all available service catalogs |
| [Get Catalog](docs/service_catalog.md#get-catalog) | Retrieve details of a specific catalog |
| [Get Categories](docs/service_catalog.md#get-categories) | Retrieve all available catalog categories |
| [Get Category](docs/service_catalog.md#get-category) | Retrieve details of a specific category |
| [Get Items](docs/service_catalog.md#get-items) | Retrieve all available catalog items |
| [Get Item](docs/service_catalog.md#get-item) | Retrieve details of a specific catalog item |
| [Search Items](docs/service_catalog.md#search-items) | Search for catalog items by search term |
| [Get Cart](docs/service_catalog.md#get-cart) | Retrieve current shopping cart contents |
| [Add to Cart](docs/service_catalog.md#add-to-cart) | Add a catalog item to the shopping cart |
| [Update Cart Item](docs/service_catalog.md#update-cart-item) | Update a catalog item in the shopping cart |
| [Remove from Cart](docs/service_catalog.md#remove-from-cart) | Remove a catalog item from the shopping cart |
| [Empty Cart](docs/service_catalog.md#empty-cart) | Remove all items from the shopping cart |
| [Checkout Cart](docs/service_catalog.md#checkout-cart) | Checkout the shopping cart |
| [Submit Order](docs/service_catalog.md#submit-order) | Submit the shopping cart as an order |

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
