# frozen_string_literal: true

require "rails_helper"

describe "game/_surroundings.html.erb", type: :view do
  subject(:html) do
    render(
      partial: "game/surroundings",
      locals:  { room: room }
    )

    rendered
  end

  let(:character_1) { build_stubbed(:character, name: "Alex") }
  let(:character_2) { build_stubbed(:character, name: "Jody") }
  let(:room)        { build_stubbed(:room, characters: [character_2, character_1]) }

  it "renders the surroundings" do
    expect(html).to have_css("#surroundings")
  end

  it "renders the surrounding characters ordered by name" do
    expect(html).to have_css(
      "#surrounding-characters #surrounding_character_#{character_1.id}", text: character_1.name
    ).and(
      have_css(
        "#surrounding-characters #surrounding_character_#{character_2.id}", text: character_2.name
      )
    ).and(
      have_css(
        "#surrounding-characters " \
        "#surrounding_character_#{character_1.id} + " \
        "#surrounding_character_#{character_2.id}"
      )
    )
  end
end
