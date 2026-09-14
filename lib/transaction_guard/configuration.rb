# frozen_string_literal: true

module TransactionGuard
  # Stores TransactionGuard configuration.
  class Configuration
    attr_accessor :mode

    def initialize
      @mode = :warn
    end

    def enabled?
      mode != :off
    end
  end
end
