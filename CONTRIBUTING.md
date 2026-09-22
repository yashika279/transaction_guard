# Contributing to TransactionGuard

Thanks for helping improve TransactionGuard.

## How to contribute

`master` is protected. Direct pushes are not accepted.

1. **Fork** the repository on GitHub.
2. **Clone your fork** and create a branch from `master`.
3. Make your changes, then open a **pull request** against `master` on
   [yashika279/transaction_guard](https://github.com/yashika279/transaction_guard).

```bash
git clone https://github.com/<your-username>/transaction_guard.git
cd transaction_guard
git remote add upstream https://github.com/yashika279/transaction_guard.git
git checkout -b my-change
bundle install
```

Keep your branch up to date before opening the PR:

```bash
git fetch upstream
git rebase upstream/master
```

## Feedback and issues

Use [GitHub Issues](https://github.com/yashika279/transaction_guard/issues) for:

* Bug reports
* Feature ideas
* Questions and general feedback

Prefer the issue templates when they fit. Include:

1. Ruby / Rails / ActiveRecord versions
2. TransactionGuard mode (`:warn`, `:raise`, or `:off`)
3. A minimal reproduction if possible

Security vulnerabilities should be reported privately — see [SECURITY.md](SECURITY.md).

## Checks before opening a PR

```bash
bundle exec rspec
bundle exec rubocop
```

CI must pass on your pull request before it can be merged.

## Guidelines

- Keep the public API small and focused on detecting side effects inside ActiveRecord transactions.
- Prefer optional integrations (load when the library is present) over hard runtime dependencies.
- Add or update specs for behavior changes.
- Update `CHANGELOG.md` under `[Unreleased]` when relevant.
- Be respectful and follow the [Code of Conduct](CODE_OF_CONDUCT.md).
