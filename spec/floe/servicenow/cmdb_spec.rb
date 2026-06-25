# frozen_string_literal: true

RSpec.describe Floe::ServiceNow::Cmdb do
  let(:secrets) do
    {
      "username" => "admin",
      "password" => "password"
    }
  end
  let(:context) { double("context") }

  before do
    # Mock the http method to avoid actual HTTP calls
    allow(described_class).to receive(:http).and_call_original
  end

  describe ".get_ci" do
    let(:params) { {"instance_id" => "dev12345", "sys_id" => "abc123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "name" => "Server01", "ip_address" => "192.168.1.1"}} }

      it "retrieves a CI and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/cmdb_ci/abc123", stub_http_success(response_body))

        result = described_class.get_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with custom table" do
      let(:params) { {"instance_id" => "dev12345", "sys_id" => "abc123", "table" => "cmdb_ci_server"} }
      let(:response_body) { {"result" => {"sys_id" => "abc123", "name" => "Server01"}} }

      it "retrieves a CI from custom table" do
        mock_http_call(described_class, "GET", "/api/now/table/cmdb_ci_server/abc123", stub_http_success(response_body))

        result = described_class.get_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.get_ci(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Error"]).to eq("States.TaskFailed")
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end

    context "with missing credentials" do
      let(:secrets) { {} }

      it "returns error for missing username" do
        result = described_class.get_ci(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Error"]).to eq("States.TaskFailed")
        expect(result["output"]["Cause"]).to eq("Missing Credential: username")
      end
    end
  end

  describe ".query_cis" do
    let(:params) { {"instance_id" => "dev12345", "query" => "ip_address=192.168.1.1", "limit" => "10", "method" => "GET"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "abc123", "name" => "Server01"}, {"sys_id" => "def456", "name" => "Server02"}]} }

      it "queries CIs and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/cmdb_ci", stub_http_success(response_body))

        result = described_class.query_cis(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with custom table" do
      let(:params) { {"instance_id" => "dev12345", "table" => "cmdb_ci_server", "method" => "GET"} }
      let(:response_body) { {"result" => []} }

      it "queries CIs from custom table" do
        mock_http_call(described_class, "GET", "/api/now/table/cmdb_ci_server", stub_http_success(response_body))

        result = described_class.query_cis(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.query_cis(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".create_ci" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "attributes"  => {
          "name"       => "Server01",
          "ip_address" => "192.168.1.1"
        }
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "name" => "Server01", "ip_address" => "192.168.1.1"}} }

      it "creates a CI and returns success" do
        mock_http_call(described_class, "POST", "/api/now/table/cmdb_ci", stub_http_success(response_body))

        result = described_class.create_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with custom table" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "table"       => "cmdb_ci_server",
          "name"        => "Server01"
        }
      end
      let(:response_body) { {"result" => {"sys_id" => "abc123"}} }

      it "creates a CI in custom table" do
        mock_http_call(described_class, "POST", "/api/now/table/cmdb_ci_server", stub_http_success(response_body))

        result = described_class.create_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {"table" => "cmdb_ci_server"} }

      it "returns error for missing name" do
        result = described_class.create_ci(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".update_ci" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "sys_id"      => "abc123",
        "ip_address"  => "192.168.1.2"
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "abc123", "ip_address" => "192.168.1.2"}} }

      it "updates a CI and returns success" do
        mock_http_call(described_class, "PATCH", "/api/now/table/cmdb_ci/abc123", stub_http_success(response_body))

        result = described_class.update_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with custom table" do
      let(:params) do
        {
          "instance_id" => "dev12345",
          "table"       => "cmdb_ci_server",
          "sys_id"      => "abc123",
          "ip_address"  => "192.168.1.2"
        }
      end
      let(:response_body) { {"result" => {"sys_id" => "abc123"}} }

      it "updates a CI in custom table" do
        mock_http_call(described_class, "PATCH", "/api/now/table/cmdb_ci_server/abc123", stub_http_success(response_body))

        result = described_class.update_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.update_ci(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end
  end

  describe ".delete_ci" do
    let(:params) { {"instance_id" => "dev12345", "sys_id" => "abc123"} }

    context "with valid parameters" do
      let(:response_body) { {} }

      it "deletes a CI and returns success" do
        mock_http_call(described_class, "DELETE", "/api/now/table/cmdb_ci/abc123", stub_http_success(response_body))

        result = described_class.delete_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with custom table" do
      let(:params) { {"instance_id" => "dev12345", "table" => "cmdb_ci_server", "sys_id" => "abc123"} }
      let(:response_body) { {} }

      it "deletes a CI from custom table" do
        mock_http_call(described_class, "DELETE", "/api/now/table/cmdb_ci_server/abc123", stub_http_success(response_body))

        result = described_class.delete_ci(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.delete_ci(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end
  end

  describe ".get_ci_relationships" do
    let(:params) { {"instance_id" => "dev12345", "sys_id" => "abc123"} }

    context "with valid parameters" do
      let(:ci_response_body) { {"result" => {"sys_id" => "abc123", "name" => "Server01"}} }
      let(:rel_response_body) { {"result" => [{"parent" => "abc123", "child" => "def456", "type" => "Runs on::Runs"}]} }

      it "retrieves CI relationships and returns success" do
        # Mock both HTTP calls
        call_count = 0
        allow(described_class).to receive(:http) do |params, _secrets, _context|
          call_count += 1
          if call_count == 1 && params["Url"].include?("/api/now/cmdb/instance/cmdb_ci/abc123")
            stub_http_success(ci_response_body)
          elsif call_count == 2 && params["Url"].include?("/api/now/table/cmdb_rel_ci")
            stub_http_success(rel_response_body)
          else
            raise "Unexpected HTTP call: #{params['Method']} #{params['Url']}"
          end
        end

        result = described_class.get_ci_relationships(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]["sys_id"]).to eq("abc123")
        expect(result["output"]["relationships"]).to eq(rel_response_body["result"])
      end
    end

    context "with missing sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing sys_id" do
        result = described_class.get_ci_relationships(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: sys_id")
      end
    end
  end

  describe ".create_ci_relationship" do
    let(:params) do
      {
        "instance_id"       => "dev12345",
        "parent_sys_id"     => "abc123",
        "child_sys_id"      => "def456",
        "relationship_type" => "Runs on::Runs"
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "rel123", "parent" => "abc123", "child" => "def456"}} }

      it "creates a CI relationship and returns success" do
        mock_http_call(described_class, "POST", "/api/now/table/cmdb_rel_ci", stub_http_success(response_body))

        result = described_class.create_ci_relationship(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with custom connection_strength" do
      let(:params) do
        {
          "instance_id"         => "dev12345",
          "parent_sys_id"       => "abc123",
          "child_sys_id"        => "def456",
          "relationship_type"   => "Runs on::Runs",
          "connection_strength" => "2"
        }
      end
      let(:response_body) { {"result" => {"sys_id" => "rel123"}} }

      it "creates a CI relationship with custom strength" do
        mock_http_call(described_class, "POST", "/api/now/table/cmdb_rel_ci", stub_http_success(response_body))

        result = described_class.create_ci_relationship(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing parent_sys_id" do
      let(:params) do
        {
          "instance_id"       => "dev12345",
          "child_sys_id"      => "def456",
          "relationship_type" => "Runs on::Runs"
        }
      end

      it "returns error for missing parent_sys_id" do
        result = described_class.create_ci_relationship(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: parent_sys_id")
      end
    end

    context "with missing child_sys_id" do
      let(:params) do
        {
          "instance_id"       => "dev12345",
          "parent_sys_id"     => "abc123",
          "relationship_type" => "Runs on::Runs"
        }
      end

      it "returns error for missing child_sys_id" do
        result = described_class.create_ci_relationship(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: child_sys_id")
      end
    end

    context "with missing relationship_type" do
      let(:params) do
        {
          "instance_id"   => "dev12345",
          "parent_sys_id" => "abc123",
          "child_sys_id"  => "def456"
        }
      end

      it "returns error for missing relationship_type" do
        result = described_class.create_ci_relationship(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: relationship_type")
      end
    end
  end

  describe ".get_ci_classes" do
    let(:params) { {"instance_id" => "dev12345"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"name" => "cmdb_ci_server", "label" => "Server"}, {"name" => "cmdb_ci_computer", "label" => "Computer"}]} }

      it "retrieves CI classes and returns success" do
        mock_http_call(described_class, "GET", "/api/now/table/sys_db_object", stub_http_success(response_body))

        result = described_class.get_ci_classes(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with limit parameter" do
      let(:params) { {"instance_id" => "dev12345", "limit" => "5"} }
      let(:response_body) { {"result" => []} }

      it "retrieves limited CI classes" do
        mock_http_call(described_class, "GET", "/api/now/table/sys_db_object", stub_http_success(response_body))

        result = described_class.get_ci_classes(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.get_ci_classes(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end
end
