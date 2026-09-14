# frozen_string_literal: true

require "transaction_guard"
require "active_record"
require "action_mailer"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveJob::Base.queue_adapter = :test

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

class TestMailer < ActionMailer::Base
  def welcome
    mail(
      to: "test@example.com",
      subject: "Welcome",
      body: "Welcome to TransactionGuard"
    )
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after do
    TransactionGuard.configure do |transaction_guard|
      transaction_guard.mode = :warn
    end
  end
end
