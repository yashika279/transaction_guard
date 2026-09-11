# frozen_string_literal: true

require "active_record"
require_relative "transaction_guard/configuration"
require_relative "transaction_guard/version"
require_relative "transaction_guard/transaction"

module TransactionGuard
  class Error < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
