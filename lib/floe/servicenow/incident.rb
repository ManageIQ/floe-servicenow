# frozen_string_literal: true

require "json"

module Floe
  module ServiceNow
    class Incident < Floe::ServiceNow::Methods
      # Create a new incident in ServiceNow
      def self.create_incident(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_create_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        http_params = build_http_params(
          "POST",
          "/api/now/table/incident",
          params,
          secrets,
          :body => params.except("instance_id")
        )

        http_request(http_params, {}, {})
      end

      # Get an incident by sys_id
      def self.get_incident(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_get_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        sys_id = params["sys_id"]

        http_params = build_http_params(
          "GET",
          "/api/now/table/incident/#{sys_id}",
          params,
          secrets
        )

        http_request(http_params, {}, {})
      end

      # Update an existing incident
      def self.update_incident(params, secrets, _context)
        error = verify_credentials(secrets)
        return ServiceNow.error!({}, :cause => error) if error

        error = verify_update_params(params)
        return ServiceNow.error!({}, :cause => error) if error

        sys_id = params["sys_id"]

        http_params = build_http_params(
          "PATCH",
          "/api/now/table/incident/#{sys_id}",
          params,
          secrets,
          :body => params.except("sys_id", "instance_id")
        )

        http_request(http_params, {}, {})
      end

      def self.resolve_incident(params, secrets, context)
        params['attributes'] ||= {}
        params['attributes']['state'] = '6' # state enum 6 is resolved
        params['attributes']['resolution_code'] = params.delete('close_code') if params['close_code']
        params['attributes']['resolution_notes'] = params.delete('close_notes') if params['close_notes']

        update_incident(params, secrets, context)
      end

      def self.close_incident(params, secrets, context)
        params['attributes'] ||= {}
        params['attributes']['state'] = '7' # state enum 7 is closed
        params['attributes']['resolution_code'] = params.delete('close_code') if params['close_code']
        params['attributes']['resolution_notes'] = params.delete('close_notes') if params['close_notes']

        update_incident(params, secrets, context)
      end

      # Query incidents with optional filters
      def self.query_incidents(params, secrets, _context)
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
          "/api/now/table/incident",
          params,
          secrets,
          :query => query_params
        )

        http_request(http_params, {}, {})
      end

      # Verify parameters for create_incident
      private_class_method def self.verify_create_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: short_description" if params["short_description"].nil?

        nil
      end

      # Verify parameters for get_incident
      private_class_method def self.verify_get_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: sys_id" if params["sys_id"].nil?

        nil
      end

      # Verify parameters for update_incident
      private_class_method def self.verify_update_params(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?
        return "Missing Parameter: sys_id" if params["sys_id"].nil?

        nil
      end
    end
  end
end
