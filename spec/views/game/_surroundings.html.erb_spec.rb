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
    let(:character_first)  { create(:character, name: "Rory") }
    let(:character_second) { create(:character, :inactive, name: "Jody") }
    let(:character_third)  { create(:character, name: "Alex") }

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
          "#surrounding_character_#{character_third.id} + " \
          "#surrounding_character_#{character_first.id}"
        )
      )
    end

    it "does not render the surrounding, inactive characters" do
      expect(html).to have_no_css("#surrounding_character_#{character_second.id}")
    end
  end

  context "with items" do
    let(:room) { create(:room) }

    it "renders the surrounding items ordered by name" do
      item_second = create(:item, owner: room, name: "Knife")
      item_first  = create(:item, owner: room, name: "Dagger")

      expect(html).to have_css(
        "#surrounding-items #surrounding_item_#{item_first.id}"
      ).and(
        have_css(
          "#surrounding-items #surrounding_item_#{item_second.id}"
        )
      ).and(
        have_css(
          "#surrounding-items " \
          "#surrounding_item_#{item_first.id} + " \
          "#surrounding_item_#{item_second.id}"
        )
      )
    end
  end

  context "with monsters" do
    let(:monster_first)  { create(:monster, room: room, name: "Blob") }
    let(:monster_second) { create(:monster, room: room, name: "Rat") }
    let(:room)           { create(:room) }

    before do
      create(:spawn, :monster, entity: monster_second, room: room)
      create(:spawn, :monster, entity: monster_first, room: room)
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

  context "with npcs" do
    let(:npc_first)  { create(:npc, room: room, name: "Bartender") }
    let(:npc_second) { create(:npc, room: room, name: "Shopkeeper") }
    let(:room)       { create(:room) }

    before do
      create(:spawn, :npc, entity: npc_second, room: room)
      create(:spawn, :npc, entity: npc_first, room: room)
    end

    it "renders the surrounding npcs ordered by name" do
      expect(html).to have_css(
        "#surrounding-npcs #surrounding_npc_#{npc_first.id}"
      ).and(
        have_css(
          "#surrounding-npcs #surrounding_npc_#{npc_second.id}"
        )
      ).and(
        have_css(
          "#surrounding-npcs " \
          "#surrounding_npc_#{npc_first.id} + " \
          "#surrounding_npc_#{npc_second.id}"
        )
      )
    end
  end
end
