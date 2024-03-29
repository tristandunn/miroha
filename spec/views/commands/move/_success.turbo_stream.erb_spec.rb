# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/move/success",
      formats: :turbo_stream,
      locals:  {
        room_source: room_source,
        room_target: room_target
      }
    )

    rendered
  end

  let(:room_source) { build_stubbed(:room) }
  let(:room_target) { build_stubbed(:room) }

  before do
    stub_template("commands/look/_success.html.erb" => "LOOK_SUCCESS_TEMPLATE")
    stub_template("game/_surroundings.html.erb" => "SURROUNDINGS_TEMPLATE")
  end

  it "renders the look success Turbo stream template" do
    expect(html).to include("LOOK_SUCCESS_TEMPLATE")
  end

  it "renders the move surroundings Turbo stream template" do
    expect(html).to include("SURROUNDINGS_TEMPLATE")
  end

  it "removes the room source stream" do
    expect(html).to have_turbo_stream_element(
      action: :remove,
      target: dom_id(room_source)
    )
  end

  it "appends the room target stream to the streams" do
    expect(html).to have_turbo_stream_element(
      action: :append,
      target: :streams
    )
  end

  it "renders the room target stream source" do
    template = html.match(
      %r{<turbo-stream action="append" target="streams"><template>(.*)</template>}m
    )[1]

    expect(template).to have_css(
      %(turbo-cable-stream-source[id="#{dom_id(room_target)}"])
    )
  end
end
