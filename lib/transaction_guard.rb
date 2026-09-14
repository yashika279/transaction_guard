# frozen_string_literal: true

require "active_record"
require "net/http"
require "action_mailer"
require "active_job"

require_relative "transaction_guard/configuration"
require_relative "transaction_guard/version"
require_relative "transaction_guard/transaction"
require_relative "transaction_guard/detectors/http"
require_relative "transaction_guard/reporter"
require_relative "transaction_guard/detectors/mail"
require_relative "transaction_guard/detectors/job"

# Detects external side effects performed inside ActiveRecord transactions.
module TransactionGuard
  class Error < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
Net::HTTP.prepend(TransactionGuard::Detectors::HTTP)

ActionMailer::MessageDelivery.prepend(TransactionGuard::Detectors::Mail)
ActiveJob::Base.singleton_class.prepend(TransactionGuard::Detectors::Job)
