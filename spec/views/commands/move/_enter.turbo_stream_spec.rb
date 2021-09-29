# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_enter.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/move/enter",
      formats: :turbo_stream,
      locals:  {
        character: character,
        direction: direction
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:direction) { :north }

  before do
    stub_template("commands/move/_enter.html.erb" => "ENTER_TEMPLATE")
    stub_template("game/surroundings/_character.html.erb" => "CHARACTER_TEMPLATE")
  end

  it "appends an enter message to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "appends the character to the surrounding characters" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "surrounding-characters"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("ENTER_TEMPLATE")
  end

  it "renders the surrounding character template" do
    expect(html).to include("CHARACTER_TEMPLATE")
  end
end
