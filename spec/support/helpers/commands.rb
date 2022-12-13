# frozen_string_literal: true

module RSpec
  module Helpers
    module Commands
      module Feature
        def send_command(command, *arguments)
          send_text("/#{command} #{arguments.join(" ")}")
        end

        def send_text(text)
          find("#command input").tap do |input|
            input.fill_in(with: text)
            input.native.send_keys(:return)
          end
        end
      end

      RSpec.configure do |config|
        config.include Feature, type: :feature
      end
    end
  end
end
