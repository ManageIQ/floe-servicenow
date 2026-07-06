# frozen_string_literal: true

RSpec.describe Floe::ServiceNow::ServiceCatalog do
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

  describe ".submit_catalog_item" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "item_sys_id" => "item123",
        "variables"   => {"quantity" => "1", "location" => "Building A"}
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"request_id" => "req123", "request_number" => "REQ0001"}} }

      it "submits a catalog item order and returns success" do
        mock_http_call(described_class, "POST", "/api/sn_sc/servicecatalog/items/item123/order_now", stub_http_success(response_body))

        result = described_class.submit_catalog_item(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing item_sys_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing item_sys_id" do
        result = described_class.submit_catalog_item(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: item_sys_id")
      end
    end

    context "with missing instance_id" do
      let(:params) { {"item_sys_id" => "item123"} }

      it "returns error for missing instance_id" do
        result = described_class.submit_catalog_item(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".get_request" do
    let(:params) { {"instance_id" => "dev12345", "request_id" => "req123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "req123", "number" => "REQ0001", "state" => "approved"}} }

      it "retrieves a request and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/requests/req123", stub_http_success(response_body))

        result = described_class.get_request(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing request_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing request_id" do
        result = described_class.get_request(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: request_id")
      end
    end
  end

  describe ".get_requested_item" do
    let(:params) { {"instance_id" => "dev12345", "requested_item_id" => "ritm123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "ritm123", "number" => "RITM0001", "state" => "closed_complete"}} }

      it "retrieves a requested item and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/items/ritm123", stub_http_success(response_body))

        result = described_class.get_requested_item(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing requested_item_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing requested_item_id" do
        result = described_class.get_requested_item(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: requested_item_id")
      end
    end
  end

  describe ".get_catalogs" do
    let(:params) { {"instance_id" => "dev12345"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "cat1", "title" => "IT Services"}]} }

      it "retrieves catalogs and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/catalogs", stub_http_success(response_body))

        result = described_class.get_catalogs(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.get_catalogs(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".get_catalog" do
    let(:params) { {"instance_id" => "dev12345", "catalog_id" => "cat123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "cat123", "title" => "IT Services", "categories" => []}} }

      it "retrieves a catalog and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/catalogs/cat123", stub_http_success(response_body))

        result = described_class.get_catalog(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing catalog_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing catalog_id" do
        result = described_class.get_catalog(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: catalog_id")
      end
    end
  end

  describe ".get_categories" do
    let(:params) { {"instance_id" => "dev12345"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "cat1", "title" => "Hardware"}]} }

      it "retrieves categories and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/categories", stub_http_success(response_body))

        result = described_class.get_categories(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.get_categories(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".get_category" do
    let(:params) { {"instance_id" => "dev12345", "category_id" => "cat123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "cat123", "title" => "Hardware", "items" => []}} }

      it "retrieves a category and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/categories/cat123", stub_http_success(response_body))

        result = described_class.get_category(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing category_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing category_id" do
        result = described_class.get_category(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: category_id")
      end
    end
  end

  describe ".get_items" do
    let(:params) { {"instance_id" => "dev12345"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "item1", "name" => "Laptop"}]} }

      it "retrieves items and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/items", stub_http_success(response_body))

        result = described_class.get_items(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.get_items(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".get_item" do
    let(:params) { {"instance_id" => "dev12345", "item_id" => "item123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"sys_id" => "item123", "name" => "Laptop", "variables" => []}} }

      it "retrieves an item and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/items/item123", stub_http_success(response_body))

        result = described_class.get_item(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing item_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing item_id" do
        result = described_class.get_item(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: item_id")
      end
    end
  end

  describe ".search_items" do
    let(:params) { {"instance_id" => "dev12345", "search_term" => "laptop"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => [{"sys_id" => "item1", "name" => "Dell Laptop"}]} }

      it "searches items and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/items", stub_http_success(response_body))

        result = described_class.search_items(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing search_term" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing search_term" do
        result = described_class.search_items(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: search_term")
      end
    end
  end

  describe ".get_cart" do
    let(:params) { {"instance_id" => "dev12345"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"cart_id" => "cart123", "items" => []}} }

      it "retrieves cart and returns success" do
        mock_http_call(described_class, "GET", "/api/sn_sc/servicecatalog/cart", stub_http_success(response_body))

        result = described_class.get_cart(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.get_cart(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".add_to_cart" do
    let(:params) do
      {
        "instance_id" => "dev12345",
        "item_id"     => "item123",
        "quantity"    => 2,
        "variables"   => {"color" => "blue"}
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"cart_item_id" => "ci123", "status" => "added"}} }

      it "adds item to cart and returns success" do
        mock_http_call(described_class, "POST", "/api/sn_sc/servicecatalog/cart/default/add_item", stub_http_success(response_body))

        result = described_class.add_to_cart(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing item_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing item_id" do
        result = described_class.add_to_cart(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: item_id")
      end
    end
  end

  describe ".update_cart_item" do
    let(:params) do
      {
        "instance_id"  => "dev12345",
        "cart_item_id" => "ci123",
        "quantity"     => 3
      }
    end

    context "with valid parameters" do
      let(:response_body) { {"result" => {"cart_item_id" => "ci123", "status" => "updated"}} }

      it "updates cart item and returns success" do
        mock_http_call(described_class, "POST", "/api/sn_sc/servicecatalog/cart/default/update_item", stub_http_success(response_body))

        result = described_class.update_cart_item(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing cart_item_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing cart_item_id" do
        result = described_class.update_cart_item(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: cart_item_id")
      end
    end
  end

  describe ".remove_from_cart" do
    let(:params) { {"instance_id" => "dev12345", "cart_item_id" => "ci123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"status" => "removed"}} }

      it "removes item from cart and returns success" do
        mock_http_call(described_class, "DELETE", "/api/sn_sc/servicecatalog/cart/default/remove_item", stub_http_success(response_body))

        result = described_class.remove_from_cart(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing cart_item_id" do
      let(:params) { {"instance_id" => "dev12345"} }

      it "returns error for missing cart_item_id" do
        result = described_class.remove_from_cart(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: cart_item_id")
      end
    end
  end

  describe ".empty_cart" do
    let(:params) { {"instance_id" => "dev12345"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"status" => "emptied"}} }

      it "empties cart and returns success" do
        mock_http_call(described_class, "DELETE", "/api/sn_sc/servicecatalog/cart/default/empty", stub_http_success(response_body))

        result = described_class.empty_cart(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.empty_cart(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".checkout_cart" do
    let(:params) { {"instance_id" => "dev12345", "special_instructions" => "Urgent"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"request_id" => "req123", "status" => "submitted"}} }

      it "checks out cart and returns success" do
        mock_http_call(described_class, "POST", "/api/sn_sc/servicecatalog/cart/checkout", stub_http_success(response_body))

        result = described_class.checkout_cart(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.checkout_cart(params, secrets, context)

        expect(result["success"]).to be false
        expect(result["output"]["Cause"]).to eq("Missing Parameter: instance_id")
      end
    end
  end

  describe ".submit_order" do
    let(:params) { {"instance_id" => "dev12345", "requested_for" => "user123"} }

    context "with valid parameters" do
      let(:response_body) { {"result" => {"request_id" => "req123", "status" => "submitted"}} }

      it "submits order and returns success" do
        mock_http_call(described_class, "POST", "/api/sn_sc/servicecatalog/cart/submit_order", stub_http_success(response_body))

        result = described_class.submit_order(params, secrets, context)

        expect(result["success"]).to be true
        expect(result["output"]).to eq(response_body)
      end
    end

    context "with missing instance_id" do
      let(:params) { {} }

      it "returns error for missing instance_id" do
        result = described_class.submit_order(params, secrets, context)

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

  describe ".build_submit_catalog_item_body" do
    it "excludes routing params and preserves variables" do
      params = {
        "instance_id" => "dev12345",
        "item_sys_id" => "item123",
        "variables"   => {"quantity" => "1"},
        "other_param" => "value"
      }

      body = described_class.send(:build_submit_catalog_item_body, params)

      expect(body).to eq({"variables" => {"quantity" => "1"}, "other_param" => "value"})
      expect(body).not_to have_key("instance_id")
      expect(body).not_to have_key("item_sys_id")
    end
  end
end
