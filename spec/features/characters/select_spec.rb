# frozen_string_literal: true

require "rails_helper"

describe "Selecting a character", :js do
  let(:character) { create(:character, :inactive) }

  before do
    sign_in_as character.account
    visit characters_path
  end

  it "successfully" do
    click_on character.name

    expect(page).to have_css("#sidebar h1", text: character.name)
  end

  it "displays room description in chat", js: false do
    click_on character.name

    expect(page).to have_look_message(character.room.description)
  end

  it "displays character inventory" do
    item = create(:item, owner: character)

    click_on character.name

    expect(page).to have_inventory_item(item)
  end

  it "displays active characters in surroundings", js: false do
    nearby_character = create(:character, room: character.room)

    click_on character.name

    expect(page).to have_surrounding_character(nearby_character)
  end

  it "displays monsters in surroundings", js: false do
    monster = create(:monster, room: character.room)

    click_on character.name

    expect(page).to have_surrounding_monster(monster)
  end

  it "displays items in surroundings", js: false do
    item = create(:item, owner: character.room)

    click_on character.name

    expect(page).to have_surrounding_item(item)
  end

  it "broadcasts an enter message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    click_on character.name

    using_session(:nearby_character) do
      expect(page).to have_css(
        "#messages .message-enter-game",
        text: t("characters.enter.message", name: character.name)
      )
    end
  end

  it "appends the character to the surroundings" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    click_on character.name

    using_session(:nearby_character) do
      expect(page).to have_surrounding_character(character)
    end
  end

  it "does not display inactive characters in surroundings", js: false do
    inactive_character = create(:character, :inactive, room: character.room)

    click_on character.name

    expect(page).not_to have_surrounding_character(inactive_character)
  end

  it "does not broadcast the enter message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    click_on character.name

    using_session(:distant_character) do
      expect(page).to have_no_css("#messages .message-enter-game")
    end
  end

  it "does not allow quick repeated selection", :cache, js: false do
    Rails.cache.write(Character::SELECTED_KEY % character.id, 1, expires_in: 5.minutes)

    click_on character.name

    expect(page).to have_text(
      t("activemodel.errors.models.character_select_form.attributes.base.character_recent")
    )
  end
end
