# frozen_string_literal: true

RSpec.describe Floe::ServiceNow::Incident do
  let(:secrets) do
    {
      "username" => "admin",
      "password" => "password"
    }
  end
  let(:context) { double("context") }

  before do
    allow(described_class).to receive(:http).and_call_original
  end

  describe ".create_incident" do
    let(:params) do
      {
        "instance_id"       => "dev12345",
        "short_description" => "Test incident",
        "description"       => "Test description"
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "number" => "INC0001"}} }

      it "creates an incident and returns success" do
        mock_http_call(described_class, "POST", "/api/now/table/incident", stub_http_success(response_body))

        result = described_class.create_incident(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing credentials" do
      let(:secrets) { {} }

      it "returns error for missing username" do
        result = described_class.create_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Credentials: Provide either (username and password) or access_token")
      end
    end

    context "with missing parameters" do
      let(:params) { {"short_description" => "Test"} }

      it "returns error for missing instance_url" do
        result = described_class.create_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end

    context "with authentication error" do
      let(:secrets) { {"username" => "bad", "password" => "wrong"} }

      it "returns error for authentication failure" do
        mock_http_call(described_class, "POST", "/api/now/table/incident", stub_http_error(401, "Authentication failed"))

        result = described_class.create_incident(params, secrets, context)

        expect(result["output"]["Error"]).to eq("States.Http.StatusCode.401")
      end
    end
  end

  describe ".get_incident" do
    let(:params) { {"instance_id" => "dev12345", "sys_id" => "abc123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "number" => "INC0001", "state" => "1"}} }

      it "retrieves an incident and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.get_incident(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.get_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end

    context "with missing instance_id" do
      let(:params) { {"sys_id" => "abc123"} }

      it "returns error for missing instance_id" do
        result = described_class.get_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end

    context "with not found error" do
      it "returns error for resource not found" do
        mock_http_call(described_class, "GET", "/api/now/table/incident/abc123", stub_http_error(404, "Not found"))

        result = described_class.get_incident(params, secrets, context)

        expect(result["output"]["Error"]).to eq("States.Http.StatusCode.404")
      end
    end
  end

  describe ".update_incident" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "sys_id"      => "abc123",
        "state"       => "2"
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "state" => "2"}} }

      it "updates an incident and returns success" do
        mock_http_call(described_class, "PATCH", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.update_incident(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345", "state" => "2"} }

      it "returns error for missing sys_id" do
        result = described_class.update_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end

    context "with missing instance_id" do
      let(:params) { {"sys_id" => "abc123", "state" => "2"} }

      it "returns error for missing instance_id" do
        result = described_class.update_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".resolve_incident" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "sys_id"      => "abc123",
        "close_notes" => "Issue resolved",
        "close_code"  => "Solved (Permanently)"
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "state" => "6"}} }

      it "resolves an incident and returns success" do
        mock_http_call(described_class, "PATCH", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.resolve_incident(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.resolve_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end

    context "with missing instance_id" do
      let(:params) { {"sys_id" => "abc123"} }

      it "returns error for missing instance_id" do
        result = described_class.resolve_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".close_incident" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "sys_id"      => "abc123",
        "close_notes" => "Closed",
        "close_code"  => "Solved (Permanently)"
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "state" => "7"}} }

      it "closes an incident and returns success" do
        mock_http_call(described_class, "PATCH", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.close_incident(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.close_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end

    context "with missing instance_id" do
      let(:params) { {"sys_id" => "abc123"} }

      it "returns error for missing instance_id" do
        result = described_class.close_incident(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".query_incidents" do
    let(:params) { {"instance_id" => "dev12345", "query" => "state=1", "limit" => "10"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "abc123", "number" => "INC0001"}]} }

      it "queries incidents and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/incident", stub_http_success(response_body))

        result = described_class.query_incidents(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with no query parameters" do
      let(:params) { {"instance_id" => "dev12345"} }
      let(:response_body) { {"result" => []} }

      it "queries all incidents" do
        mock_http_call(described_class, "GET", "/api/now/table/incident", stub_http_success(response_body))

        result = described_class.query_incidents(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.query_incidents(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".verify_credentials" do
    it "returns nil for valid credentials" do
      expect(described_class.send(:verify_credentials, secrets)).to be_nil
    end

    it "returns error for missing username" do
      expect(described_class.send(:verify_credentials, {"password" => "pass"})).to eq("Missing Credentials: Provide either (username and password) or access_token")
    end

    it "returns error for missing password" do
      expect(described_class.send(:verify_credentials, {"username" => "user"})).to eq("Missing Credentials: Provide either (username and password) or access_token")
    end
  end
end
