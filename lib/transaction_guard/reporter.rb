# frozen_string_literal: true

module TransactionGuard
  # Reports detected external side effects.
  module Reporter
    module_function

    def report(operation:)
      message = build_message(operation)

      case TransactionGuard.configuration.mode
      when :warn
        warn message
      when :raise
        raise TransactionGuard::Error, message
      when :off
        nil
      end
    end

    def build_message(operation)
      <<~MESSAGE
        ⚠ TransactionGuard
        External side effect detected inside an ActiveRecord transaction.
        Operation: #{operation}
        Risk: The external operation cannot be rolled back automatically if the DB transaction later rolls back.
        Consider: after_commit, ActiveJob, transactional outbox
      MESSAGE
    end
    private_class_method :build_message
  end
end
