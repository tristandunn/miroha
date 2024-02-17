# frozen_string_literal: true

module Dispatchable
  extend ActiveSupport::Concern

  class_methods do
    # Only return records with event handlers.
    #
    # @return [ActiveRecord::Relation]
    def with_event_handlers(*events)
      EventHandlers.for(*events).inject(nil) do |scope, handler|
        handler = handler.to_s.delete_prefix("EventHandlers::")

        query = where("event_handlers LIKE ?", "%#{handler}%")
        query || scope.or(query)
      end
    end
  end

  # Return the event handler classes for the monster.
  #
  # @return [Array] The event handler classes.
  def event_handlers
    @event_handlers ||= read_attribute(:event_handlers).filter_map do |handler|
      suppress(NameError) do
        EventHandlers.const_get(handler, false)
      end
    end
  end

  # Trigger an event on the dispatchable class.
  #
  # @return [void]
  def trigger(event, **arguments, &block)
    name = self.class.name.underscore.to_sym

    event_handlers.each do |handler|
      if block.present?
        handler.try("before_#{event}", name => self, **arguments)

        yield

        handler.try("after_#{event}", name => self, **arguments)
      else
        handler.try("on_#{event}", name => self, **arguments)
      end
    end
  end
end
