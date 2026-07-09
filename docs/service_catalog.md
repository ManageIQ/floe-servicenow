# Service Catalog API Methods

## Table of Contents

| Method | Description |
|--------|-------------|
| [Submit Catalog Item](#submit-catalog-item) | Submit a catalog item order directly |
| [Get Request](#get-request) | Retrieve details of a service catalog request |
| [Get Requested Item](#get-requested-item) | Retrieve summary of a requested catalog item |
| [Get Catalogs](#get-catalogs) | Retrieve all available service catalogs |
| [Get Catalog](#get-catalog) | Retrieve details of a specific catalog |
| [Get Categories](#get-categories) | Retrieve all available catalog categories |
| [Get Category](#get-category) | Retrieve details of a specific category |
| [Get Items](#get-items) | Retrieve all available catalog items |
| [Get Item](#get-item) | Retrieve details of a specific catalog item |
| [Search Items](#search-items) | Search for catalog items by search term |
| [Get Cart](#get-cart) | Retrieve current shopping cart contents |
| [Add to Cart](#add-to-cart) | Add a catalog item to the shopping cart |
| [Update Cart Item](#update-cart-item) | Update a catalog item in the shopping cart |
| [Remove from Cart](#remove-from-cart) | Remove a catalog item from the shopping cart |
| [Empty Cart](#empty-cart) | Remove all items from the shopping cart |
| [Checkout Cart](#checkout-cart) | Checkout the shopping cart |
| [Submit Order](#submit-order) | Submit the shopping cart as an order |

## Submit Catalog Item

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

## Get Request

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

## Get Requested Item

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

## Get Catalogs

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

## Get Catalog

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

## Get Categories

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

## Get Category

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

## Get Items

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

## Get Item

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

## Search Items

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

## Get Cart

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

## Add to Cart

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

## Update Cart Item

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

## Remove from Cart

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

## Empty Cart

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

## Checkout Cart

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

## Submit Order

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
