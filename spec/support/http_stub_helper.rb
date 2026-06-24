# frozen_string_literal: true

module Spec
  module Support
    module HttpStubHelper
      def stub_http_success(body)
        {
          "output" => {
            "Status"  => 200,
            "Body"    => body,
            "Headers" => {}
          }
        }
      end

      def stub_http_error(status, message)
        {
          "success" => false,
          "output"  => {
            "Error"   => "States.Http.StatusCode.#{status}",
            "Cause"   => message,
            "Details" => {
              "Status"  => status,
              "Body"    => {},
              "Headers" => {}
            }
          }
        }
      end

      def mock_http_call(klass, expected_method, expected_path, response)
        allow(klass).to receive(:http) do |params, _secrets, _context|
          if params["Method"] == expected_method && params["Url"].include?(expected_path)
            response
          else
            raise "Unexpected HTTP call: #{params['Method']} #{params['Url']}"
          end
        end
      end
    end
  end
end
