# frozen_string_literal: true

module Dispatchable
  extend ActiveSupport::Concern

  class_methods do
    # Only return records with event handlers.
    #
    # @return [ActiveRecord::Relation]
    def with_event_handlers(*events)
      handlers = EventHandlers.for(*events).map do |handler|
        handler.to_s.delete_prefix("EventHandlers::")
      end

      where("event_handlers @> ARRAY[?]::varchar[]", handlers)
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
