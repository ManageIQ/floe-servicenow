# frozen_string_literal: true

require "json"

module Floe
  module ServiceNow
    class Cmdb < Floe::ServiceNow::Methods
      # Get a Configuration Item (CI) by sys_id
      def self.get_ci(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_ci_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        table = params["table"] || "cmdb_ci"
        sys_id = params["sys_id"]

        http_params = build_http_params(
          "GET",
          "/api/now/table/#{table}/#{sys_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      # Query Configuration Items with optional filters
      def self.query_cis(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_query_cis_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        instance_id = params["instance_id"]
        table       = params["table"] || "cmdb_ci"
        username    = secrets["username"]
        password    = secrets["password"]

        require "base64"
        authorization = "Basic #{::Base64.urlsafe_encode64("#{username}:#{password}")}"

        headers = {
          "Authorization" => authorization,
          "Content-Type"  => "application/json",
          "Accept"        => "application/json"
        }

        query_params = {}
        query_params["sysparm_query"]  = params["query"]  if params["query"]
        query_params["sysparm_limit"]  = params["limit"]  if params["limit"]
        query_params["sysparm_offset"] = params["offset"] if params["offset"]
        query_params["sysparm_fields"] = params["fields"] if params["fields"]

        http_params = {
          "Method"          => params["method"],
          "Url"             => "https://#{instance_id}.service-now.com/api/now/table/#{table}",
          "Options"         => {"Encoding" => "JSON"},
          "Headers"         => headers,
          "QueryParameters" => query_params
        }

        begin
          http_request(http_params, {}, {})
        rescue => err
          ServiceNow.error!({}, :cause => err.to_s)
        end
      end

      # Create a new Configuration Item
      def self.create_ci(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_create_ci_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        table = params["table"] || "cmdb_ci"

        http_params = build_http_params(
          "POST",
          "/api/now/table/#{table}",
          params,
          secrets,
          :body => params.except("instance_id", "table")
        )

        http_request(http_params, {}, {})
      end

      # Update an existing Configuration Item
      def self.update_ci(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_update_ci_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        table = params["table"] || "cmdb_ci"
        sys_id = params["sys_id"]

        http_params = build_http_params(
          "PATCH",
          "/api/now/table/#{table}/#{sys_id}",
          params,
          secrets,
          :body => params.except("sys_id", "instance_id", "table")
        )

        http_request(http_params, {}, {})
      end

      # Delete a Configuration Item
      def self.delete_ci(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_delete_ci_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        table = params["table"] || "cmdb_ci"
        sys_id = params["sys_id"]

        http_params = build_http_params(
          "DELETE",
          "/api/now/table/#{table}/#{sys_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      # Get CI relationships
      def self.get_ci_relationships(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_ci_relationships_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        sys_id = params["sys_id"]

        # Get CI instance
        query_params = {
          "sysparm_display_value"          => "true",
          "sysparm_exclude_reference_link" => "true"
        }

        http_params = build_http_params(
          "GET",
          "/api/now/cmdb/instance/cmdb_ci/#{sys_id}",
          params,
          secrets,
          :query => query_params
        )

        ci_response = http_request(http_params, {}, {})
        return ci_response unless ci_response["success"]

        # Get relationships
        rel_query_params = {
          "sysparm_query"         => "parent=#{sys_id}^ORchild=#{sys_id}",
          "sysparm_display_value" => "true"
        }

        rel_http_params = build_http_params(
          "GET",
          "/api/now/table/cmdb_rel_ci",
          params,
          secrets,
          :query => rel_query_params
        )

        rel_response = http_request(rel_http_params, {}, {})
        return rel_response unless rel_response["success"]

        # Merge results
        ci_data = ci_response["output"]["result"]
        rel_data = rel_response["output"]["result"]
        output = ci_data.merge("relationships" => rel_data)

        ServiceNow.success!({}, :output => output)
      end

      # Create a CI relationship
      def self.create_ci_relationship(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_create_ci_relationship_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        body = {
          "parent"              => params["parent_sys_id"],
          "child"               => params["child_sys_id"],
          "type"                => params["relationship_type"],
          "connection_strength" => params["connection_strength"] || "1"
        }

        http_params = build_http_params(
          "POST",
          "/api/now/table/cmdb_rel_ci",
          params,
          secrets,
          :body => body
        )

        http_request(http_params, {}, {})
      end

      # Get CI classes (types)
      def self.get_ci_classes(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        query_params = {
          "sysparm_query"  => "nameSTARTSWITHcmdb_ci",
          "sysparm_fields" => "name,label,super_class"
        }
        query_params["sysparm_limit"] = params["limit"] if params["limit"]

        http_params = build_http_params(
          "GET",
          "/api/now/table/sys_db_object",
          params,
          secrets,
          :query => query_params
        )

        http_request(http_params, {}, {})
      end

      # Verify parameters for get_ci
      private_class_method def self.verify_get_ci_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: sys_id"      if params["sys_id"].nil?

        nil
      end

      # Verify parameters for query_cis
      private_class_method def self.verify_query_cis_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      # Verify parameters for create_ci
      private_class_method def self.verify_create_ci_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      # Verify parameters for update_ci
      private_class_method def self.verify_update_ci_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: sys_id"      if params["sys_id"].nil?

        nil
      end

      # Verify parameters for delete_ci
      private_class_method def self.verify_delete_ci_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: sys_id"      if params["sys_id"].nil?

        nil
      end

      # Verify parameters for get_ci_relationships
      private_class_method def self.verify_get_ci_relationships_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: sys_id"      if params["sys_id"].nil?

        nil
      end

      # Verify parameters for create_ci_relationship
      private_class_method def self.verify_create_ci_relationship_params(params)
        return "Missing Parameter: instance_id"       if params["instance_id"].nil?
        return "Missing Parameter: parent_sys_id"     if params["parent_sys_id"].nil?
        return "Missing Parameter: child_sys_id"      if params["child_sys_id"].nil?
        return "Missing Parameter: relationship_type" if params["relationship_type"].nil?

        nil
      end
    end
  end
end
