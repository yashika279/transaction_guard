# frozen_string_literal: true

module TransactionGuard
  module Detectors
    # Detects email delivery inside ActiveRecord transactions.
    module Mail
      def deliver_now(...)
        report_email unless mail_delivery_in_progress?

        with_mail_delivery { super }
      end

      def deliver_later(...)
        report_email unless mail_delivery_in_progress?

        with_mail_delivery { super }
      end

      private

      def report_email
        return unless TransactionGuard::Transaction.open?

        TransactionGuard::Reporter.report(operation: "Email delivery")
      end

      def mail_delivery_in_progress?
        Thread.current[:transaction_guard_mail_delivery]
      end

      def with_mail_delivery
        Thread.current[:transaction_guard_mail_delivery] = true
        yield
      ensure
        Thread.current[:transaction_guard_mail_delivery] = false
      end
    end
  end
end
