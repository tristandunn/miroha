# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/navigation/_content.html.erb" do
  subject(:html) do
    render partial: "game/sidebar/navigation/content",
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the container" do
    expect(html).to have_css("div")
  end

  context "when character has items" do
    let(:character)   { create(:character, items: [item_first, item_second]) }
    let(:item_first)  { build(:item, name: "Gloves") }
    let(:item_second) { build(:item, name: "Amulet") }

    it "renders the character items ordered by name" do
      expect(html).to have_css(
        "#character-inventory #inventory_item_#{item_first.id}"
      ).and(
        have_css(
          "#character-inventory #inventory_item_#{item_second.id}"
        )
      ).and(
        have_css(
          "#character-inventory " \
          "#inventory_item_#{item_second.id} + " \
          "#inventory_item_#{item_first.id}"
        )
      )
    end
  end

  context "when character has no items" do
    it "does not render the inventory list" do
      expect(html).to have_no_css("#character-inventory ol")
    end
  end
end
