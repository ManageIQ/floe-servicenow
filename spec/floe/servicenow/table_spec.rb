# frozen_string_literal: true

RSpec.describe Floe::ServiceNow::Table do
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

  describe ".list_tables" do
    let(:params) { {"instance_id" => "dev12345", "query" => "nameSTARTSWITHcmdb"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"name" => "cmdb_ci", "label" => "Configuration Item"}, {"name" => "cmdb_ci_server", "label" => "Server"}]} }

      it "lists tables and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/sys_db_object", stub_http_success(response_body))

        result = described_class.list_tables(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with no query parameters" do
      let(:params) { {"instance_id" => "dev12345"} }
      let(:response_body) { {"result" => []} }

      it "lists all tables" do
        mock_http_call(described_class, "GET", "/api/now/table/sys_db_object", stub_http_success(response_body))

        result = described_class.list_tables(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.list_tables(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".query_records" do
    let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "query" => "active=true"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "123", "number" => "INC0001", "short_description" => "Test incident"}]} }

      it "queries records and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/incident", stub_http_success(response_body))

        result = described_class.query_records(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with optional parameters" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "limit" => 10, "fields" => "number,short_description"} }
      let(:response_body) { {"result" => []} }

      it "includes query parameters" do
        mock_http_call(described_class, "GET", "/api/now/table/incident", stub_http_success(response_body))

        result = described_class.query_records(params, secrets, context)

        expect(result["success"]).to be true
      end
    end

    context "with missing table_name" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing table_name" do
        result = described_class.query_records(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: table_name")
      end
    end
  end

  describe ".get_record" do
    let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "sys_id" => "abc123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "number" => "INC0001", "short_description" => "Test incident"}} }

      it "gets record and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.get_record(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with optional fields parameter" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "sys_id" => "abc123", "fields" => "number,short_description"} }
      let(:response_body) { {"result" => {"sys_id" => "abc123", "number" => "INC0001"}} }

      it "includes fields query parameter" do
        mock_http_call(described_class, "GET", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.get_record(params, secrets, context)

        expect(result["success"]).to be true
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident"} }

      it "returns error for missing sys_id" do
        result = described_class.get_record(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end
  end

  describe ".create_record" do
    let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "data" => {"short_description" => "New incident", "urgency" => "2"}} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "xyz789", "number" => "INC0002", "short_description" => "New incident"}} }

      it "creates record and returns success" do
        mock_http_call(described_class, "POST", "/api/now/table/incident", stub_http_success(response_body))

        result = described_class.create_record(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing data" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident"} }

      it "returns error for missing data" do
        result = described_class.create_record(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: data")
      end
    end
  end

  describe ".update_record" do
    let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "sys_id" => "abc123", "data" => {"short_description" => "Updated incident", "state" => "2"}} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "number" => "INC0001", "short_description" => "Updated incident"}} }

      it "updates record and returns success" do
        mock_http_call(described_class, "PUT", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.update_record(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing data" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "sys_id" => "abc123"} }

      it "returns error for missing data" do
        result = described_class.update_record(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: data")
      end
    end
  end

  describe ".patch_record" do
    let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "sys_id" => "abc123", "data" => {"state" => "3"}} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "number" => "INC0001", "state" => "3"}} }

      it "patches record and returns success" do
        mock_http_call(described_class, "PATCH", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.patch_record(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "data" => {"state" => "3"}} }

      it "returns error for missing sys_id" do
        result = described_class.patch_record(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end
  end

  describe ".delete_record" do
    let(:params) { {"instance_id" => "dev12345", "table_name" => "incident", "sys_id" => "abc123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"success" => true}} }

      it "deletes record and returns success" do
        mock_http_call(described_class, "DELETE", "/api/now/table/incident/abc123", stub_http_success(response_body))

        result = described_class.delete_record(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345", "table_name" => "incident"} }

      it "returns error for missing sys_id" do
        result = described_class.delete_record(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end
  end

  describe ".verify_credentials" do
    it "returns nil for valid credentials" do
      expect(described_class.send(:verify_credentials, secrets)).to be_nil
    end

    it "returns error for missing username" do
      expect(described_class.send(:verify_credentials, {"password" => "pass"})).to eq("Missing Credential: username")
    end

    it "returns error for missing password" do
      expect(described_class.send(:verify_credentials, {"username" => "user"})).to eq("Missing Credential: password")
    end
  end
end
