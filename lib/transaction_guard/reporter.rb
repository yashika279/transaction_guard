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
      location = caller_location
      details = ["Operation: #{operation}"]
      details << "Location: #{location}" if location

      <<~MESSAGE
        ⚠ TransactionGuard
        External side effect detected inside an ActiveRecord transaction.
        #{details.join("\n")}
        Risk: The external operation cannot be rolled back automatically if the DB transaction later rolls back.
        Consider: after_commit, ActiveJob after commit, transactional outbox
      MESSAGE
    end
    private_class_method :build_message

    def caller_location
      caller_locations(1, 40)&.find do |frame|
        path = frame.absolute_path || frame.path
        path && !path.include?("/transaction_guard/")
      end&.to_s
    end
    private_class_method :caller_location
  end
end
