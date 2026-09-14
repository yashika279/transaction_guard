# TransactionGuard

TransactionGuard detects external side effects performed inside ActiveRecord transactions.

Database transactions can roll back database changes, but they cannot automatically roll back operations such as:

* HTTP requests
* Email delivery
* Background job enqueueing

For example:

```ruby
User.transaction do
  user = User.create!(name: "Yashika")

  SomeExternalApi.create_user(user)
end
```

If the transaction later rolls back, the external API request cannot automatically be rolled back with it.

TransactionGuard helps identify these situations during development and testing.

## Installation

Add the gem to your application's Gemfile:

```ruby
gem "transaction_guard"
```

Then run:

```bash
bundle install
```

For local development, you can use the gem directly from a local path:

```ruby
gem "transaction_guard", path: "../transaction_guard"
```

## Configuration

TransactionGuard supports three modes:

* `:warn` — report external side effects
* `:raise` — raise an error when a side effect is detected
* `:off` — disable detection

The default mode is `:warn`.

Configure TransactionGuard in an initializer:

```ruby
TransactionGuard.configure do |config|
  config.mode = :warn
end
```

### Warn mode

This is the default:

```ruby
TransactionGuard.configure do |config|
  config.mode = :warn
end
```

When an external side effect is detected inside a transaction, TransactionGuard reports a warning.

Example:

```ruby
User.transaction do
  Net::HTTP.get(URI("https://example.com"))
end
```

The warning explains the risk and suggests safer alternatives.

### Raise mode

Use `:raise` when you want to prevent the transaction from continuing after an external side effect is detected:

```ruby
TransactionGuard.configure do |config|
  config.mode = :raise
end
```

An invalid configuration value raises an `ArgumentError`:

```ruby
TransactionGuard.configure do |config|
  config.mode = :invalid
end
```

### Off mode

Detection can be disabled:

```ruby
TransactionGuard.configure do |config|
  config.mode = :off
end
```

## HTTP detection

TransactionGuard detects HTTP requests made through `Net::HTTP` while an ActiveRecord transaction is open.

Example:

```ruby
User.transaction do
  Net::HTTP.get(URI("https://example.com"))
end
```

TransactionGuard reports the external HTTP operation.

The detector covers common `Net::HTTP` methods including:

```ruby
get
post
put
patch
delete
head
options
```

## Email detection

TransactionGuard detects email delivery performed inside an ActiveRecord transaction.

For example:

```ruby
User.transaction do
  user = User.create!

  TestMailer.welcome(user).deliver_now
end
```

It also detects:

```ruby
User.transaction do
  TestMailer.welcome(user).deliver_later
end
```

`deliver_later` is reported as an email side effect rather than generating an additional warning for the internal ActiveJob enqueue.

## Background job detection

TransactionGuard detects ActiveJob operations performed inside transactions.

### Enqueueing a job

```ruby
User.transaction do
  user = User.create!

  WelcomeJob.perform_later(user.id)
end
```

This is reported as a job enqueue operation.

### Executing a job immediately

```ruby
User.transaction do
  WelcomeJob.perform_now
end
```

This is reported as job execution.

## Why does this matter?

Consider:

```ruby
User.transaction do
  user = User.create!

  WelcomeJob.perform_later(user.id)

  raise ActiveRecord::Rollback
end
```

The database record is rolled back, but the background job may already have been enqueued.

The job could therefore execute with an ID that no longer exists.

Similar problems can occur with HTTP requests and email delivery.

## Recommended alternatives

When an external side effect depends on a successful database transaction, consider moving the operation until after the transaction commits.

For example:

```ruby
user = User.create!

User.transaction do
  user.update!(status: "active")
end

WelcomeJob.perform_later(user.id)
```

For more complex workflows, consider patterns such as:

* `after_commit`
* ActiveJob triggered after a successful commit
* transactional outbox
* reliable event publishing

TransactionGuard does not automatically move, delay, retry, or otherwise modify external operations. It reports the potentially unsafe operation so the application can decide how to handle it.

## Development

Clone the repository and install dependencies:

```bash
git clone https://github.com/yashika279/transaction_guard.git
cd transaction_guard
bundle install
```

Run the test suite:

```bash
bundle exec rspec
```

Run RuboCop:

```bash
bundle exec rubocop
```

Build the gem locally:

```bash
bundle exec gem build transaction_guard.gemspec
```

## Contributing

Bug reports, feature requests, and pull requests are welcome.

Please make sure tests and RuboCop pass before submitting a pull request.

## License

TransactionGuard is available as open source under the MIT License.
