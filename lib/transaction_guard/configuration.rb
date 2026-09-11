# frozen_string_literal: true

module TransactionGuard
  class Configuration
    attr_accessor :mode

    def initialize
      @mode = :warn
    end
  end
end
