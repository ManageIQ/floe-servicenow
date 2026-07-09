# frozen_string_literal: true

module Floe
  module ServiceNow
    class Methods < Floe::BuiltinRunner::Methods
      private_class_method def self.verify_credentials(secrets)
        return "Missing Credentials" if secrets.nil?

        # Allow either username/password OR access_token
        has_basic_auth = secrets["username"] && secrets["password"]
        has_oauth = secrets["access_token"]

        return "Missing Credentials: Provide either (username and password) or access_token" unless has_basic_auth || has_oauth

        nil
      end

      private_class_method def self.verify_instance_id(params)
        return "Missing Parameter: instance_id" if params["instance_id"].nil?

        nil
      end

      private_class_method def self.verify_required_param(params, param_name)
        return "Missing Parameter: #{param_name}" if params[param_name].nil?

        nil
      end

      private_class_method def self.build_http_params(method, path, params, secrets, options = {})
        instance_id = params["instance_id"]

        # Build authorization header - support both Basic Auth and OAuth
        if secrets["access_token"]
          authorization = "Bearer #{secrets["access_token"]}"
        elsif secrets["username"] && secrets["password"]
          require "base64"
          authorization = "Basic #{::Base64.urlsafe_encode64("#{secrets["username"]}:#{secrets["password"]}")}"
        end

        headers = {
          "Content-Type" => "application/json",
          "Accept"       => "application/json"
        }
        headers["Authorization"] = authorization if authorization

        http_params = {
          "Method"  => method,
          "Url"     => "https://#{instance_id}.service-now.com#{path}",
          "Options" => {"Encoding" => "JSON"},
          "Headers" => headers
        }

        http_params["QueryParameters"] = options[:query] if options[:query]
        http_params["Body"] = options[:body] if options[:body]

        http_params
      end

      # Wrapper around http() that returns only the Body wrapped in success response
      private_class_method def self.http_request(http_params, secrets, context)
        response = http(http_params, secrets, context)

        # If there's an error at the top level, return it as-is
        return response if response.key?("success") && !response["success"]

        # Extract the Body and wrap in success response
        body = response.dig("output", "Body") || response
        ServiceNow.success!({}, :output => body)
      end
    end
  end
end
