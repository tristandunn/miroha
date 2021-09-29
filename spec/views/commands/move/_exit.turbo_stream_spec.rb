# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_exit.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/move/exit",
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
    stub_template("commands/move/_exit.html.erb" => "EXIT_TEMPLATE")
  end

  it "appends an exit message to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "removes the character from the surrounding characters element" do
    expect(html).to have_turbo_stream_element(
      action: "remove",
      data:   { character_id: character.id },
      target: "surrounding_character_#{character.id}"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("EXIT_TEMPLATE")
  end
end
