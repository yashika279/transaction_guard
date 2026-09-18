## [Unreleased]

## [0.1.0] - 2026-09-18

### Added

- Detect `Net::HTTP` requests inside ActiveRecord transactions
- Detect ActionMailer `deliver_now` / `deliver_later` inside transactions
- Detect ActiveJob `perform_later` / `perform_now` inside transactions
- Configuration modes: `:warn` (default), `:raise`, and `:off`
- Rails Railtie with development/test `:warn` and production `:off` defaults
- Caller location in warning and error messages
