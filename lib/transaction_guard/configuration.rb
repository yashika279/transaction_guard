# frozen_string_literal: true

module TransactionGuard
  # Stores TransactionGuard configuration.
  class Configuration
    MODES = %i[off warn raise].freeze

    attr_reader :mode

    def initialize
      @mode = :warn
    end

    def mode=(value)
      raise ArgumentError, "Invalid mode: #{value.inspect}" unless MODES.include?(value)

      @mode = value
    end

    def enabled?
      mode != :off
    end
  end
end
