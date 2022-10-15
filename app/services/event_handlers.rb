# frozen_string_literal: true

module EventHandlers
  # Return all the event handler classes.
  #
  # @return [Array] All event handler classes.
  def self.all
    @all ||= constants
             .map { |name| const_get(name) }
             .select { |constant| constant.is_a?(Module) }
             .flat_map do |group|
               group.constants
                    .map { |name| group.const_get(name) }
                    .select { |constant| constant.is_a?(Class) }
             end
  end

  # Return event handler classes for specific events.
  #
  # @param [Array] events The events to filter for.
  # @return [Array] Event handler classes for the provided events.
  def self.for(*events)
    events.flat_map do |event|
      all.select do |handler|
        handler.respond_to?("on_#{event}") ||
          handler.respond_to?("before_#{event}") ||
          handler.respond_to?("after_#{event}")
      end
    end
  end
end
