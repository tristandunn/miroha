# frozen_string_literal: true

suppress(LoadError) do
  require "parallel_tests/cli"

  namespace :ruby do
    desc "Run all the Ruby tests in parallel"
    task test: "tailwindcss:build" do
      FileUtils.rm_rf("tmp/cache/coverage")

      ParallelTests::CLI.new.run(
        [
          "--type", "rspec",
          "--quiet",
          "--test-options", "--format ParallelMatrixFormatter::Formatter",
          "spec"
        ]
      )

      if ENV.fetch("CI", ENV.fetch("COVERAGE", false))
        require "simplecov"
        require "simplecov-console"

        SimpleCov.collate(Dir["tmp/cache/coverage/.resultset.json"], "rails") do
          coverage_dir "./tmp/cache/coverage"
          enable_coverage :branch
          formatter SimpleCov::Formatter::Console
          minimum_coverage line: 100, branch: 100
        end
      end
    end
  end
end

suppress(LoadError) do
  require "rubocop/rake_task"

  RuboCop::RakeTask.new("ruby:lint") do |task|
    task.options = %w(--parallel)
  end
end

namespace :erb do
  desc "Run `bundle exec erb_lint`"
  task :lint do # rubocop:disable Rails/RakeEnvironment
    system("bundle exec erb_lint .") ||
      exit($CHILD_STATUS.exitstatus)
  end
end
