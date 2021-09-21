# frozen_string_literal: true

module RSpec
  module Helpers
    module Identifier
      module Service
        # Returns the DOM ID for the record.
        #
        # @param [ActiveRecord::Base] record The record to get the ID for.
        # @param [String|nil| prefix A custom identifier prefix.
        # @return [String]
        def dom_id(record, prefix = nil)
          ActionView::RecordIdentifier.dom_id(record, prefix)
        end
      end

      RSpec.configure do |config|
        config.include Service, type: :service
      end
    end
  end
end
