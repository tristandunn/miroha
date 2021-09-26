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

  let(:character_1) { create(:character, name: "Alex") }
  let(:character_2) { create(:character, name: "Jody") }
  let(:character_3) { create(:character, :inactive, name: "Rory") }
  let(:room)        { create(:room, characters: [character_1, character_2, character_3]) }

  it "renders the surroundings" do
    expect(html).to have_css("#surroundings")
  end

  it "renders the surrounding, active characters ordered by name" do
    expect(html).to have_css(
      "#surrounding-characters #surrounding_character_#{character_1.id}"
    ).and(
      have_css(
        "#surrounding-characters #surrounding_character_#{character_2.id}"
      )
    ).and(
      have_css(
        "#surrounding-characters " \
        "#surrounding_character_#{character_1.id} + " \
        "#surrounding_character_#{character_2.id}"
      )
    )
  end

  it "does not render the surrounding, inactive characters" do
    expect(html).not_to have_css("#surrounding_character_#{character_3.id}")
  end
end
