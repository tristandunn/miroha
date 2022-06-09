# frozen_string_literal: true

Clock.start
Clock.pause

module RSpec
  module Helpers
    module Clock
      module Feature
        def run(name)
          job = Rufus::Scheduler.singleton.jobs.find { |value| value.name == name }
          job.call
        end
      end

      RSpec.configure do |config|
        config.include Feature, type: :feature, clock: true
      end
    end
  end
end
