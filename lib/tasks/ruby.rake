# frozen_string_literal: true

begin
  require "rspec/core/rake_task"

  namespace :ruby do
    desc "Run all the Ruby tests"
    task test: :spec
  end
rescue LoadError # rubocop:disable Lint/SuppressedException
end

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new("ruby:lint") do |task|
    task.options = %w(--parallel)
  end
rescue LoadError # rubocop:disable Lint/SuppressedException
end

namespace :erb do
  desc "Run `bundle exec erblint`"
  task :lint do # rubocop:disable Rails/RakeEnvironment
    system("bundle exec erblint .") ||
      exit($CHILD_STATUS.exitstatus)
  end
end
