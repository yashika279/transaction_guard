# frozen_string_literal: true

RSpec.describe TransactionGuard::Reporter do
  describe ".report" do
    it "warns in warn mode" do
      configure_mode(:warn)

      expect do
        described_class.report(operation: "HTTP request")
      end.to output(/External side effect detected/).to_stderr
    end

    it "raises in raise mode" do
      configure_mode(:raise)

      expect do
        described_class.report(operation: "HTTP request")
      end.to raise_error(TransactionGuard::Error)
    end

    it "includes caller location in the message" do
      configure_mode(:warn)

      expect do
        described_class.report(operation: "HTTP request")
      end.to output(/Location:/).to_stderr
    end

    it "does nothing in off mode" do
      configure_mode(:off)

      expect do
        described_class.report(operation: "HTTP request")
      end.not_to output.to_stderr
    end
  end

  def configure_mode(mode)
    TransactionGuard.configure { |config| config.mode = mode }
  end
end
