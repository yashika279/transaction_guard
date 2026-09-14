# frozen_string_literal: true

RSpec.describe TransactionGuard::Configuration do
  describe "#mode" do
    it "defaults to warn" do
      expect(described_class.new.mode).to eq(:warn)
    end
  end
end

RSpec.describe TransactionGuard do
  describe ".configure" do
    it "allows configuring the mode" do
      described_class.configure do |config|
        config.mode = :raise
      end

      expect(described_class.configuration.mode).to eq(:raise)
    end

    it "rejects an invalid mode" do
      expect do
        TransactionGuard::Configuration.new.mode = :invalid
      end.to raise_error(ArgumentError, /Invalid mode/)
    end
  end
end
