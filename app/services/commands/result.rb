# frozen_string_literal: true

module Commands
  class Result
    # Define an attribute reader for each local and a method to return a hash
    # for all the locals.
    #
    # @return [void]
    def self.locals(*names)
      attr_reader(*names)

      define_method(:locals) do
        names.each.with_object({}) do |name, result|
          result[name] = send(name)
        end
      end
    end

    # A no-op definition for calling the result.
    #
    # @return [void]
    def call
      nil
    end

    # Return the options for rendering the result.
    #
    # @return [Hash]
    def render_options
      {
        locals:  try(:locals),
        partial: partial
      }
    end

    # Determine if the result is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    # Broadcast an append later, with automatic partial.
    #
    # @param [Array] streamables Channel streamables to broadcast to.
    # @param [String] target The append target.
    # @param [Hash] custom_render_options Custom rendering options.
    # @return [void]
    def broadcast_append_later_to(*streamables, target:, **custom_render_options)
      Turbo::StreamsChannel.broadcast_append_later_to(
        *streamables,
        target: target,
        **render_options.merge(custom_render_options)
      )
    end

    # Broadcast a render later, with automatic partial.
    #
    # @param [Array] streamables Channel streamables to broadcast to.
    # @param [Hash] custom_render_options Custom rendering options.
    # @return [void]
    def broadcast_render_later_to(*streamables, **custom_render_options)
      Turbo::StreamsChannel.broadcast_render_later_to(
        *streamables,
        **render_options.merge(custom_render_options)
      )
    end

    # Broadcast a replace later, with automatic partial.
    #
    # @param [Array] streamables Channel streamables to broadcast to.
    # @param [String] target The append target.
    # @param [Hash] custom_render_options Custom rendering options.
    # @return [void]
    def broadcast_replace_later_to(*streamables, target:, **custom_render_options)
      Turbo::StreamsChannel.broadcast_replace_later_to(
        *streamables,
        target: target,
        **render_options.merge(custom_render_options)
      )
    end

    # Returns the default partial path.
    #
    # @return [String]
    def partial
      self.class.to_s.sub("Command::", "::").underscore
    end
  end
end
