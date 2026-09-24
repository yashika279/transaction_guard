## [Unreleased]

### Changed

- Clarify in the README that `after_commit` fixes rollback ordering but is not crash-safe alone; prefer an outbox when delivery must be guaranteed

## [0.1.0] - 2026-09-18

First public release of **TransactionGuard**, a Rails / ActiveRecord gem for detecting side effects inside database transactions.

- RubyGems: https://rubygems.org/gems/transaction_guard
- GitHub: https://github.com/yashika279/transaction_guard
- Site: https://yashika279.github.io/transaction_guard/

### Added

- Detect `Net::HTTP` requests inside ActiveRecord transactions
- Detect ActionMailer `deliver_now` / `deliver_later` inside transactions
- Detect ActiveJob `perform_later` / `perform_now` inside transactions
- Configuration modes: `:warn` (default), `:raise`, and `:off`
- Rails Railtie with development/test `:warn` and production `:off` defaults
- Caller location in warning and error messages

[Unreleased]: https://github.com/yashika279/transaction_guard/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yashika279/transaction_guard/releases/tag/v0.1.0
