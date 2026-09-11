# frozen_string_literal: true

require "active_record"

require_relative "transaction_guard/version"
require_relative "transaction_guard/transaction"

module TransactionGuard
  class Error < StandardError; end
  # Your code goes here...
end
