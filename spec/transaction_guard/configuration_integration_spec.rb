# frozen_string_literal: true

RSpec.describe "TransactionGuard configuration - off mode" do
  it "does not report" do
    configure_mode(:off)

    expect do
      TransactionGuard::Reporter.report(operation: "HTTP request")
    end.not_to raise_error
  end

  def configure_mode(mode)
    TransactionGuard.configure { |config| config.mode = mode }
  end
end

RSpec.describe "TransactionGuard configuration - warn mode" do
  it "reports a warning" do
    configure_mode(:warn)

    expect do
      TransactionGuard::Reporter.report(operation: "HTTP request")
    end.to output(/External side effect detected/).to_stderr
  end

  def configure_mode(mode)
    TransactionGuard.configure { |config| config.mode = mode }
  end
end

RSpec.describe "TransactionGuard configuration - raise mode" do
  it "raises an error" do
    configure_mode(:raise)

    expect do
      TransactionGuard::Reporter.report(operation: "HTTP request")
    end.to raise_error(TransactionGuard::Error)
  end

  def configure_mode(mode)
    TransactionGuard.configure { |config| config.mode = mode }
  end
end
