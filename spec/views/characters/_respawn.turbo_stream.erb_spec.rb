# frozen_string_literal: true

require "rails_helper"

describe "characters/_respawn.turbo_stream.erb" do
  subject(:html) do
    render partial: "characters/respawn",
           formats: :turbo_stream,
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  before do
    stub_template("characters/_respawn.html.erb" => "RESPAWN_TEMPLATE")
    stub_template("game/surroundings/_character.html.erb" => "CHARACTER_TEMPLATE")
  end

  it "appends a repsawn message to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "appends the character to the surrounding characters element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "surrounding-characters"
    )
  end

  it "renders the respawn HTML template" do
    expect(html).to include("RESPAWN_TEMPLATE")
  end

  it "renders the character HTML template" do
    expect(html).to include("CHARACTER_TEMPLATE")
  end
end
