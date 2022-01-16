# frozen_string_literal: true

require "zhong"
require Rails.root.join("config/clock")

module RSpec
  module Helpers
    module Zhong
      module Feature
        def run(name, time: 1.day.from_now)
          job = ::Zhong.jobs.values.find { |value| value.name == name }
          job.run(time)

          # Ensure the job can run again in other tests.
          job.clear
          job.instance_variable_set(:@first_run, true)
        end
      end

      RSpec.configure do |config|
        config.include Feature, type: :feature, zhong: true
      end
    end
  end
end
