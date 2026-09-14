# frozen_string_literal: true

RSpec.describe "TransactionGuard loading" do
  it "loads without raising an error" do
    expect { require "transaction_guard" }.not_to raise_error
  end
end
