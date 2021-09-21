# frozen_string_literal: true

module RSpec
  module Helpers
    module Commands
      module View
        # Returns a matcher for a +turbo-stream+ element.
        #
        # @param [String] action The turbo stream action.
        # @param [String] target The turbo stream target.
        # @param [Hash] data Attributes expected in the dataset.
        # @return [Capybara::RSpecMatchers::Matchers::HaveSelector]
        def have_turbo_stream_element(action:, target:, data: {})
          attributes = data.map do |key, value|
            %([data-#{key.to_s.dasherize}="#{value}"])
          end.join

          have_css(%(turbo-stream[action="#{action}"][target="#{target}"]#{attributes}))
        end
      end

      RSpec.configure do |config|
        config.include View, type: :view
      end
    end
  end
end
