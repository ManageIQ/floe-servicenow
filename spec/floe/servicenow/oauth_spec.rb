# frozen_string_literal: true

RSpec.describe Floe::ServiceNow::OAuth do
  let(:secrets) { {} }
  let(:context) { double("context") }

  before do
    allow(described_class).to receive(:http).and_call_original
  end

  describe ".token" do
    context "with password grant type" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "grant_type"  => "password",
          "client_id"   => "client123"
        }
      end

      let(:secrets) do
        {
          "client_secret" => "secret456",
          "username"      => "testuser",
          "password"      => "testpass"
        }
      end

      let(:response_body) do
        {
          "access_token"  => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "refresh_token" => "refresh_token_value",
          "scope"         => "useraccount",
          "token_type"    => "Bearer",
          "expires_in"    => 3600
        }
      end

      it "requests OAuth token with password grant and returns success" do
        mock_http_call(described_class, "POST", "/oauth_token.do", stub_http_success(response_body))

        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with client_credentials grant type" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "grant_type"  => "client_credentials",
          "client_id"   => "client123"
        }
      end

      let(:secrets) do
        {
          "client_secret" => "secret456"
        }
      end

      let(:response_body) do
        {
          "access_token" => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "scope"        => "useraccount",
          "token_type"   => "Bearer",
          "expires_in"   => 3600
        }
      end

      it "requests OAuth token with client_credentials grant and returns success" do
        mock_http_call(described_class, "POST", "/oauth_token.do", stub_http_success(response_body))

        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with refresh_token grant type" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "grant_type"  => "refresh_token",
          "client_id"   => "client123"
        }
      end

      let(:secrets) do
        {
          "client_secret" => "secret456",
          "refresh_token" => "existing_refresh_token"
        }
      end

      let(:response_body) do
        {
          "access_token"  => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "refresh_token" => "new_refresh_token",
          "scope"         => "useraccount",
          "token_type"    => "Bearer",
          "expires_in"    => 3600
        }
      end

      it "requests OAuth token with refresh_token grant and returns success" do
        mock_http_call(described_class, "POST", "/oauth_token.do", stub_http_success(response_body))

        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with authorization_code grant type" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "grant_type"  => "authorization_code",
          "client_id"   => "client123"
        }
      end

      let(:secrets) do
        {
          "client_secret" => "secret456"
        }
      end

      let(:response_body) do
        {
          "access_token"  => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "refresh_token" => "refresh_token_value",
          "scope"         => "useraccount",
          "token_type"    => "Bearer",
          "expires_in"    => 3600
        }
      end

      it "requests OAuth token with authorization_code grant and returns success" do
        mock_http_call(described_class, "POST", "/oauth_token.do", stub_http_success(response_body))

        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with minimal parameters" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "grant_type"  => "client_credentials"
        }
      end

      let(:response_body) do
        {
          "access_token" => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "token_type"   => "Bearer",
          "expires_in"   => 3600
        }
      end

      it "requests OAuth token with minimal parameters and returns success" do
        mock_http_call(described_class, "POST", "/oauth_token.do", stub_http_success(response_body))

        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) do
        {
          "grant_type" => "password",
          "client_id"  => "client123"
        }
      end

      let(:secrets) do
        {
          "client_secret" => "secret456"
        }
      end

      it "returns error for missing instance_id" do
        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end

    context "when OAuth server returns error" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "grant_type"  => "password",
          "client_id"   => "client123"
        }
      end

      let(:secrets) do
        {
          "client_secret" => "wrong_secret",
          "username"      => "testuser",
          "password"      => "testpass"
        }
      end

      let(:error_response) do
        {
          "error"             => "invalid_client",
          "error_description" => "Invalid client credentials"
        }
      end

      it "returns the error response from OAuth server" do
        mock_http_call(described_class, "POST", "/oauth_token.do", stub_http_success(error_response))

        result = described_class.token(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(error_response)
      end
    end
  end
end
