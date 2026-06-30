# frozen_string_literal: true

require "json"

module Floe
  module ServiceNow
    class Table < Floe::ServiceNow::Methods
      # List available tables
      def self.list_tables(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {}
        query_params["sysparm_query"] = params["query"] if params["query"]
        query_params["sysparm_limit"] = params["limit"] if params["limit"]
        query_params["sysparm_offset"] = params["offset"] if params["offset"]
        query_params["sysparm_fields"] = params["fields"] if params["fields"]

        http_params = build_http_params(
          "GET",
          "/api/now/table/sys_db_object",
          params,
          secrets,
          :query => query_params
        )

        http_request(http_params, {}, {})
      end

      # Query records from a table
      def self.query_records(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "table_name")
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {}
        query_params["sysparm_query"] = params["query"] if params["query"]
        query_params["sysparm_limit"] = params["limit"] if params["limit"]
        query_params["sysparm_offset"] = params["offset"] if params["offset"]
        query_params["sysparm_fields"] = params["fields"] if params["fields"]
        query_params["sysparm_display_value"] = params["display_value"] if params["display_value"]
        query_params["sysparm_exclude_reference_link"] = params["exclude_reference_link"] if params["exclude_reference_link"]

        http_params = build_http_params(
          "GET",
          "/api/now/table/#{params['table_name']}",
          params,
          secrets,
          :query => query_params
        )

        http_request(http_params, {}, {})
      end

      # Get a single record by sys_id
      def self.get_record(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "table_name")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "sys_id")
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {}
        query_params["sysparm_fields"] = params["fields"] if params["fields"]
        query_params["sysparm_display_value"] = params["display_value"] if params["display_value"]
        query_params["sysparm_exclude_reference_link"] = params["exclude_reference_link"] if params["exclude_reference_link"]

        http_params = build_http_params(
          "GET",
          "/api/now/table/#{params['table_name']}/#{params['sys_id']}",
          params,
          secrets,
          :query => query_params
        )

        http_request(http_params, {}, {})
      end

      # Create a new record
      def self.create_record(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "table_name")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "data")
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {}
        query_params["sysparm_display_value"] = params["display_value"] if params["display_value"]
        query_params["sysparm_exclude_reference_link"] = params["exclude_reference_link"] if params["exclude_reference_link"]
        query_params["sysparm_input_display_value"] = params["input_display_value"] if params["input_display_value"]

        http_params = build_http_params(
          "POST",
          "/api/now/table/#{params['table_name']}",
          params,
          secrets,
          :query => query_params,
          :body  => params["data"]
        )

        http_request(http_params, {}, {})
      end

      # Update a record (replace all fields)
      def self.update_record(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "table_name")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "sys_id")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "data")
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {}
        query_params["sysparm_display_value"] = params["display_value"] if params["display_value"]
        query_params["sysparm_exclude_reference_link"] = params["exclude_reference_link"] if params["exclude_reference_link"]
        query_params["sysparm_input_display_value"] = params["input_display_value"] if params["input_display_value"]

        http_params = build_http_params(
          "PUT",
          "/api/now/table/#{params['table_name']}/#{params['sys_id']}",
          params,
          secrets,
          :query => query_params,
          :body  => params["data"]
        )

        http_request(http_params, {}, {})
      end

      # Patch a record (update specific fields)
      def self.patch_record(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "table_name")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "sys_id")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "data")
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {}
        query_params["sysparm_display_value"] = params["display_value"] if params["display_value"]
        query_params["sysparm_exclude_reference_link"] = params["exclude_reference_link"] if params["exclude_reference_link"]
        query_params["sysparm_input_display_value"] = params["input_display_value"] if params["input_display_value"]

        http_params = build_http_params(
          "PATCH",
          "/api/now/table/#{params['table_name']}/#{params['sys_id']}",
          params,
          secrets,
          :query => query_params,
          :body  => params["data"]
        )

        http_request(http_params, {}, {})
      end

      # Delete a record
      def self.delete_record(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "table_name")
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_required_param(params, "sys_id")
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "DELETE",
          "/api/now/table/#{params['table_name']}/#{params['sys_id']}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end
    end
  end
end
