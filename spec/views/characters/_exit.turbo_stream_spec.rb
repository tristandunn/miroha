# frozen_string_literal: true

require "rails_helper"

describe "characters/_exit.turbo_stream.erb", type: :view do
  subject(:html) do
    render partial: "characters/exit",
           formats: :turbo_stream,
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  before do
    stub_template("characters/_exit.html.erb" => "EXIT_TEMPLATE")
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
      target: "surrounding_character_#{character.id}"
    )
  end

  it "renders the exit HTML template" do
    expect(html).to include("EXIT_TEMPLATE")
  end
end
