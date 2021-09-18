# Contributing

When contributing to Miroha, please first discuss the change you wish to make
via GitHub Issues before making the change.

Please note we have a [code of conduct](CODE_OF_CONDUCT.md), which you should
follow it in all your interactions with the project.

## Development Environment

### Requirements

You need the following software installed for local development:

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
- [Node.js](https://nodejs.dev/learn/how-to-install-nodejs)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Redis](https://redis.io/download)
- [Yarn](https://classic.yarnpkg.com/en/docs/install/)

### Setup

To get started, clone the repository.

```sh
git clone https://github.com/tristandunn/miroha
```

Install the dependencies and setup the database.

```sh
bin/setup
```

You can verify everything is installed and setup correctly by running the
`check` Rake task to run the tests and lint the code.

```sh
bundle exec rake check
```

You can run the application using [Foreman](https://github.com/ddollar/foreman)
and a [development `Procfile`](/Procfile.dev).

```sh
# Install Foreman if you haven't before.
gem install foreman

# Run with the development `Procfile` option.
foreman start -f Procfile.dev
```

## Issues and Feature Requests

You've found a bug in the source code, a mistake in the documentation, or maybe
you'd like a new feature? You can help by submitting an issue to [GitHub
Issues](https://github.com/tristandunn/miroha/issues). Before you create an
issue, make sure you search the archive, maybe your question was already
answered.

Please try to create bug reports that are:

- _Reproducible._ Include steps to reproduce the problem.
- _Specific._ Include as much detail as possible.
- _Unique._ Do not duplicate existing opened issues.
- _Scoped._ Limit each issue to a single bug report.

## Pull Requests

1. Search our repository for open or closed [pull
   requests](https://github.com/tristandunn/miroha/pulls) that relates to your
   submission. You don't want to duplicate effort.
1. Fork the project.
1. Create your feature branch. (`git switch -c add-new-feature`)
1. Commit your changes. (`git commit -m "Add a new feature."`)
1. Push to the branch. (`git push origin add-new-feature`)
1. Open a pull request, providing details to the template where relevant.

When you're writing a commit message, try to summarize the changes into one
sentence on the first line. If a more details are helpful, provide them in
paragraphs below the first line.
