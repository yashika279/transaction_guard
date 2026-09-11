# frozen_string_literal: true

module TransactionGuard
  module Transaction
    module_function

    def open?
      ActiveRecord::Base.current_transaction.open?
    end
  end
end
