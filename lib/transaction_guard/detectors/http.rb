# frozen_string_literal: true

module TransactionGuard
  module Detectors
    # Detects HTTP requests made inside ActiveRecord transactions.
    module HTTP
      HTTP_METHODS = %i[
        delete
        get
        head
        options
        patch
        post
        put
      ].freeze

      def request(...)
        report_http_request("HTTP request") unless http_request_in_progress?

        with_http_request { super }
      end

      HTTP_METHODS.each do |method|
        define_method(method) do |*args, **kwargs, &block|
          report_http_request("HTTP #{method.upcase}") unless http_request_in_progress?

          with_http_request do
            super(*args, **kwargs, &block)
          end
        end
      end

      private

      def report_http_request(operation)
        return unless TransactionGuard.configuration.enabled?
        return unless TransactionGuard::Transaction.open?

        TransactionGuard::Reporter.report(operation: operation)
      end

      def http_request_in_progress?
        Thread.current[:transaction_guard_http_request]
      end

      def with_http_request
        previous_state = Thread.current[:transaction_guard_http_request]
        Thread.current[:transaction_guard_http_request] = true

        yield
      ensure
        Thread.current[:transaction_guard_http_request] = previous_state
      end
    end
  end
end
