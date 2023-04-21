# frozen_string_literal: true

require "rails_helper"

describe "game/_surroundings.html.erb" do
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
    let(:character_first)  { create(:character, name: "Alex") }
    let(:character_second) { create(:character, :inactive, name: "Jody") }
    let(:character_third)  { create(:character, name: "Rory") }

    let(:room) do
      create(:room, characters: [character_first, character_second, character_third])
    end

    it "renders the surrounding, active characters ordered by name" do
      expect(html).to have_css(
        "#surrounding-characters #surrounding_character_#{character_first.id}"
      ).and(
        have_css(
          "#surrounding-characters #surrounding_character_#{character_third.id}"
        )
      ).and(
        have_css(
          "#surrounding-characters " \
          "#surrounding_character_#{character_first.id} + " \
          "#surrounding_character_#{character_third.id}"
        )
      )
    end

    it "does not render the surrounding, inactive characters" do
      expect(html).not_to have_css("#surrounding_character_#{character_second.id}")
    end
  end

  context "with monsters" do
    let(:monster_first)  { create(:monster, room: room, name: "Blob") }
    let(:monster_second) { create(:monster, room: room, name: "Rat") }
    let(:room)           { create(:room) }

    before do
      create(:spawn, :monster, entity: monster_first, room: room)
      create(:spawn, :monster, entity: monster_second, room: room)
    end

    it "renders the surrounding monsters ordered by name" do
      expect(html).to have_css(
        "#surrounding-monsters #surrounding_monster_#{monster_first.id}"
      ).and(
        have_css(
          "#surrounding-monsters #surrounding_monster_#{monster_second.id}"
        )
      ).and(
        have_css(
          "#surrounding-monsters " \
          "#surrounding_monster_#{monster_first.id} + " \
          "#surrounding_monster_#{monster_second.id}"
        )
      )
    end
  end
end
