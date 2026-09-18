# Contributing to TransactionGuard

Thanks for helping improve TransactionGuard.

## Development setup

```bash
git clone https://github.com/yashika279/transaction_guard.git
cd transaction_guard
bundle install
```

## Checks before opening a PR

```bash
bundle exec rspec
bundle exec rubocop
```

## Guidelines

- Keep the public API small and focused on detecting side effects inside ActiveRecord transactions.
- Prefer optional integrations (load when the library is present) over hard runtime dependencies.
- Add or update specs for behavior changes.
- Update `CHANGELOG.md` under `[Unreleased]` when relevant.
- Be respectful and follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Reporting issues

Open a GitHub issue with:

1. Ruby / Rails / ActiveRecord versions
2. TransactionGuard mode (`:warn`, `:raise`, or `:off`)
3. A minimal reproduction if possible
