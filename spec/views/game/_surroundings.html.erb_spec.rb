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

  let(:room) { create(:room) }

  it "renders the surroundings" do
    expect(html).to have_css("#surroundings")
  end

  context "with characters" do
    let(:character_1) { create(:character, name: "Alex") }
    let(:character_2) { create(:character, name: "Jody") }
    let(:character_3) { create(:character, :inactive, name: "Rory") }
    let(:room)        { create(:room, characters: [character_1, character_2, character_3]) }

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

  context "with monsters" do
    let(:monster_1) { create(:monster, name: "Blob") }
    let(:monster_2) { create(:monster, name: "Rat") }
    let(:room)      { create(:room, monsters: [monster_1, monster_2]) }

    it "renders the surrounding monsters ordered by name" do
      expect(html).to have_css(
        "#surrounding-monsters #surrounding_monster_#{monster_1.id}"
      ).and(
        have_css(
          "#surrounding-monsters #surrounding_monster_#{monster_2.id}"
        )
      ).and(
        have_css(
          "#surrounding-monsters " \
          "#surrounding_monster_#{monster_1.id} + " \
          "#surrounding_monster_#{monster_2.id}"
        )
      )
    end
  end
end
