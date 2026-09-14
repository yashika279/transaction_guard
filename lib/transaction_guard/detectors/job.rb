# frozen_string_literal: true

module TransactionGuard
  module Detectors
    # Detects background job operations inside ActiveRecord transactions.
    module Job
      def perform_later(...)
        report_job("Job enqueue")
        super
      end

      def perform_now(...)
        report_job("Job execution")
        super
      end

      private

      def report_job(operation)
        return if mail_delivery_in_progress?
        return unless TransactionGuard::Transaction.open?

        TransactionGuard::Reporter.report(operation: operation)
      end

      def mail_delivery_in_progress?
        Thread.current[:transaction_guard_mail_delivery]
      end
    end
  end
end
