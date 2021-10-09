# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_surroundings.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/move/surroundings",
      formats: :turbo_stream,
      locals:  {
        room: room
      }
    )

    rendered
  end

  let(:room) { build_stubbed(:room) }

  before do
    stub_template("game/_surroundings.html.erb" => "SURROUNDINGS_TEMPLATE")
  end

  it "updates the surrounding characters element" do
    expect(html).to have_turbo_stream_element(
      action: "update",
      target: "surrounding-characters"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("SURROUNDINGS_TEMPLATE")
  end
end