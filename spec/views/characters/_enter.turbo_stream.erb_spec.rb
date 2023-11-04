# frozen_string_literal: true

require "rails_helper"

describe "characters/_enter.turbo_stream.erb" do
  subject(:html) do
    render partial: "characters/enter",
           formats: :turbo_stream,
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  before do
    stub_template("characters/_enter.html.erb" => "ENTER_TEMPLATE")
    stub_template("game/surroundings/_character.html.erb" => "CHARACTER_TEMPLATE")
  end

  it "appends an enter message to the messages element" do
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

  it "renders the enter HTML template" do
    expect(html).to include("ENTER_TEMPLATE")
  end
end
