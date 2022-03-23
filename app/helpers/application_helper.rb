# frozen_string_literal: true

module ApplicationHelper
  # Return a Turbo cable stream source tag with an identifier.
  #
  # @param [Array] streamables Channel streamables to subscribe to.
  # @return [String]
  def turbo_stream_from(*streamables)
    tag.turbo_cable_stream_source(
      id:                   dom_id(*streamables),
      channel:              "Turbo::StreamsChannel",
      "signed-stream-name": Turbo::StreamsChannel.signed_stream_name(*streamables)
    )
  end
end
