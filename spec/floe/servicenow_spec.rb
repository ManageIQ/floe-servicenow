# frozen_string_literal: true

RSpec.describe Floe::ServiceNow do
  describe ".error!" do
    it "returns error runner context" do
      result = described_class.error!({}, :cause => "Test error")

      expect(result["running"]).to be false
      expect(result["success"]).to be false
      expect(result["output"]["Error"]).to eq("States.TaskFailed")
      expect(result["output"]["Cause"]).to eq("Test error")
    end

    it "accepts custom error type" do
      result = described_class.error!({}, :cause => "Test error", :error => "CustomError")

      expect(result["output"]["Error"]).to eq("CustomError")
    end

    it "merges with existing runner context" do
      context = {"method" => "test_method"}
      result = described_class.error!(context, :cause => "Test error")

      expect(result["method"]).to eq("test_method")
      expect(result["success"]).to be false
    end
  end

  describe ".success!" do
    it "returns success runner context" do
      output = {"sys_id" => "123", "number" => "INC0001"}
      result = described_class.success!({}, :output => output)

      expect(result["running"]).to be false
      expect(result["success"]).to be true
      expect(result["output"]).to eq(output)
    end

    it "merges with existing runner context" do
      context = {"method" => "test_method"}
      result = described_class.success!(context, :output => {"result" => "ok"})

      expect(result["method"]).to eq("test_method")
      expect(result["success"]).to be true
    end
  end

  describe "runner registration" do
    it "registers the servicenow scheme with Floe::Runner" do
      runner = Floe::Runner.for_resource("servicenow://create_incident")
      expect(runner).to be_a(Floe::ServiceNow::Runner)
    end
  end
end
