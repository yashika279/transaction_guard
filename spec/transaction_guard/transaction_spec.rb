# frozen_string_literal: true

RSpec.describe TransactionGuard::Transaction do
  describe ".open?" do
    context "outside a transaction" do
      it "returns false" do
        expect(described_class.open?).to be(false)
      end
    end

    context "inside a transaction" do
      it "returns true" do
        User.transaction do
          expect(described_class.open?).to be(true)
        end
      end
    end
  end
end
