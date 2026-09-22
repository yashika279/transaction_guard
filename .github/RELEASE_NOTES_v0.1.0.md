## TransactionGuard 0.1.0

First public release of **TransactionGuard** — a Rails / ActiveRecord Ruby gem that detects HTTP, email, and background-job side effects inside database transactions.

### Install

```ruby
gem "transaction_guard"
```

```bash
bundle install
```

### Links

- RubyGems: https://rubygems.org/gems/transaction_guard
- Docs: https://github.com/yashika279/transaction_guard#readme
- Site: https://yashika279.github.io/transaction_guard/
- Changelog: https://github.com/yashika279/transaction_guard/blob/master/CHANGELOG.md

### Highlights

- Detects `Net::HTTP` inside ActiveRecord transactions
- Detects ActionMailer and ActiveJob side effects inside transactions
- Modes: `:warn` (default), `:raise`, `:off`
- Rails Railtie: warn in development/test, off in production
