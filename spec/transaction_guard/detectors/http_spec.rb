# frozen_string_literal: true

require "net/http"

RSpec.shared_examples "HTTP detector" do |method, operation, *arguments|
  it "reports inside a transaction" do
    http = Net::HTTP.new("example.com", 80)

    allow(http).to receive(:request).and_return(
      instance_double(Net::HTTPResponse, code: "200")
    )

    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: operation)

    User.transaction do
      http.public_send(method, *arguments)
    end
  end
end

RSpec.describe TransactionGuard::Detectors::HTTP do
  describe "#get" do
    include_examples "HTTP detector", :get, "HTTP GET", "/"
  end

  describe "#post" do
    include_examples "HTTP detector", :post, "HTTP POST", "/", "name=TransactionGuard"
  end

  describe "outside a transaction" do
    it "does not report" do
      http = Net::HTTP.new("example.com", 80)

      allow(http).to receive(:request).and_return(
        instance_double(Net::HTTPResponse, code: "200")
      )

      expect(TransactionGuard::Reporter).not_to receive(:report)

      http.get("/")
    end
  end
end
