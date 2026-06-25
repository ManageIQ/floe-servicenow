# frozen_string_literal: true

require "json"

module Floe
  module ServiceNow
    class ServiceCatalog < Floe::ServiceNow::Methods
      def self.submit_catalog_item(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_submit_catalog_item_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        item_sys_id = params["item_sys_id"]

        http_params = build_http_params(
          "POST",
          "/api/sn_sc/servicecatalog/items/#{item_sys_id}/order_now",
          params,
          secrets,
          :body => build_submit_catalog_item_body(params)
        )

        http_request(http_params, {}, {})
      end

      def self.get_request(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_request_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        request_id = params["request_id"]

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/requests/#{request_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_requested_item(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_requested_item_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        requested_item_id = params["requested_item_id"]

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/items/#{requested_item_id}/get_item_summary",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_catalogs(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_catalogs_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/catalogs",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_catalog(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_catalog_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        catalog_id = params["catalog_id"]

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/catalogs/#{catalog_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_categories(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_categories_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/categories",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_category(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_category_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        category_id = params["category_id"]

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/categories/#{category_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_items(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_items_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/items",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_item(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_item_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        item_id = params["item_id"]

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/items/#{item_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.search_items(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_search_items_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/items",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.get_cart(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_cart_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "GET",
          "/api/sn_sc/servicecatalog/cart",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.add_to_cart(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_add_to_cart_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        cart_id = params["cart_id"] || "default"

        http_params = build_http_params(
          "POST",
          "/api/sn_sc/servicecatalog/cart/#{cart_id}/add_item",
          params,
          secrets,
          :body => build_add_to_cart_body(params)
        )

        http_request(http_params, {}, {})
      end

      def self.update_cart_item(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_update_cart_item_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        cart_id = params["cart_id"] || "default"

        http_params = build_http_params(
          "POST",
          "/api/sn_sc/servicecatalog/cart/#{cart_id}/update_item",
          params,
          secrets,
          :body => build_update_cart_item_body(params)
        )

        http_request(http_params, {}, {})
      end

      def self.remove_from_cart(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_remove_from_cart_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        cart_id = params["cart_id"] || "default"

        http_params = build_http_params(
          "DELETE",
          "/api/sn_sc/servicecatalog/cart/#{cart_id}/remove_item",
          params,
          secrets,
          :body => build_remove_from_cart_body(params)
        )

        http_request(http_params, {}, {})
      end

      def self.empty_cart(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_empty_cart_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        cart_id = params["cart_id"] || "default"

        http_params = build_http_params(
          "DELETE",
          "/api/sn_sc/servicecatalog/cart/#{cart_id}/empty",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      def self.checkout_cart(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_checkout_cart_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "POST",
          "/api/sn_sc/servicecatalog/cart/checkout",
          params,
          secrets,
          :body => build_checkout_cart_body(params)
        )

        http_request(http_params, {}, {})
      end

      def self.submit_order(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_submit_order_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "POST",
          "/api/sn_sc/servicecatalog/cart/submit_order",
          params,
          secrets,
          :body => build_submit_order_body(params)
        )

        http_request(http_params, {}, {})
      end

      private_class_method def self.verify_submit_catalog_item_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: item_sys_id" if params["item_sys_id"].nil?

        nil
      end

      private_class_method def self.verify_request_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: request_id" if params["request_id"].nil?

        nil
      end

      private_class_method def self.verify_requested_item_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: requested_item_id" if params["requested_item_id"].nil?

        nil
      end

      private_class_method def self.verify_get_catalogs_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_get_catalog_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: catalog_id" if params["catalog_id"].nil?

        nil
      end

      private_class_method def self.verify_get_categories_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_get_category_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: category_id" if params["category_id"].nil?

        nil
      end

      private_class_method def self.verify_get_items_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_get_item_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: item_id" if params["item_id"].nil?

        nil
      end

      private_class_method def self.verify_search_items_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: search_term" if params["search_term"].nil?

        nil
      end

      private_class_method def self.verify_get_cart_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_add_to_cart_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: item_id" if params["item_id"].nil?

        nil
      end

      private_class_method def self.verify_update_cart_item_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: cart_item_id" if params["cart_item_id"].nil?

        nil
      end

      private_class_method def self.verify_remove_from_cart_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: cart_item_id" if params["cart_item_id"].nil?

        nil
      end

      private_class_method def self.verify_empty_cart_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_checkout_cart_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_submit_order_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.build_submit_catalog_item_body(params)
        body = params.except("instance_id", "item_sys_id")
        body["variables"] = params["variables"] if params.key?("variables")
        body
      end

      private_class_method def self.build_add_to_cart_body(params)
        body = {
          "sysparm_item_id" => params["item_id"]
        }
        body["sysparm_quantity"] = params["quantity"] if params.key?("quantity")
        body["variables"] = params["variables"] if params.key?("variables")
        body
      end

      private_class_method def self.build_update_cart_item_body(params)
        body = {
          "sysparm_cart_item_id" => params["cart_item_id"]
        }
        body["sysparm_quantity"] = params["quantity"] if params.key?("quantity")
        body["variables"] = params["variables"] if params.key?("variables")
        body
      end

      private_class_method def self.build_remove_from_cart_body(params)
        {
          "sysparm_cart_item_id" => params["cart_item_id"]
        }
      end

      private_class_method def self.build_checkout_cart_body(params)
        body = {}
        body["sysparm_cart_id"] = params["cart_id"] if params.key?("cart_id")
        body["special_instructions"] = params["special_instructions"] if params.key?("special_instructions")
        body
      end

      private_class_method def self.build_submit_order_body(params)
        body = {}
        body["sysparm_cart_id"] = params["cart_id"] if params.key?("cart_id")
        body["requested_for"] = params["requested_for"] if params.key?("requested_for")
        body
      end
    end
  end
end
