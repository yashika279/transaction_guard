# frozen_string_literal: true

require "rails/railtie"

module TransactionGuard
  # Loads TransactionGuard in Rails applications and applies sensible defaults.
  class Railtie < Rails::Railtie
    initializer "transaction_guard.configure" do
      TransactionGuard.configure do |config|
        config.mode = Rails.env.production? ? :off : :warn
      end
    end
  end
end
