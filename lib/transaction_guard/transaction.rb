# frozen_string_literal: true

module TransactionGuard
  # Provides ActiveRecord transaction state detection.
  module Transaction
    module_function

    def open?
      ActiveRecord::Base.current_transaction.open?
    end
  end
end
