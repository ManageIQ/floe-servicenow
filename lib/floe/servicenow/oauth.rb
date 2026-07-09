# frozen_string_literal: true

require "json"

module Floe
  module ServiceNow
    class OAuth < Floe::ServiceNow::Methods
      def self.token(params, secrets, context)
        error = verify_instance_id(params)
        return ServiceNow.error!({}, :cause => error) if error

        instance_id = params["instance_id"]

        headers = {
          "ContentType" => "application/x-www-form-urlencoded",
          "Accept"      => "application/json"
        }

        body_params = {}
        body_params["grant_type"]    = params["grant_type"]     if params["grant_type"]
        body_params["client_id"]     = params["client_id"]      if params["client_id"]
        body_params["scope"]         = params["scope"]          if params["scope"]
        body_params["username"]      = secrets["username"]      if secrets["username"]
        body_params["password"]      = secrets["password"]      if secrets["password"]
        body_params["client_secret"] = secrets["client_secret"] if secrets["client_secret"]
        body_params["refresh_token"] = secrets["refresh_token"] if secrets["refresh_token"]

        http_params = {
          "Method"  => "POST",
          "Headers" => headers,
          "Url"     => "https://#{instance_id}.service-now.com/oauth_token.do",
          "Body"    => body_params
        }

        http_request(http_params, secrets, context)
      end
    end
  end
end
