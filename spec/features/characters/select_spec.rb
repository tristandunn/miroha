# frozen_string_literal: true

require "rails_helper"

describe "Selecting a character", type: :feature, js: true do
  let(:character) { create(:character, :inactive) }

  before do
    sign_in_as character.account
  end

  it "successfully" do
    click_button character.name

    expect(page).to have_css("#sidebar h1", text: character.name)
  end

  it "displays active characters in surroundings", js: false do
    nearby_character = create(:character, room: character.room)

    click_button character.name

    expect(page).to have_surrounding_character(nearby_character)
  end

  it "broadcasts an enter message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    click_button character.name

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

    click_button character.name

    using_session(:nearby_character) do
      expect(page).to have_surrounding_character(character)
    end
  end

  it "does not display inactive characters in surroundings", js: false do
    inactive_character = create(:character, :inactive, room: character.room)

    click_button character.name

    expect(page).not_to have_surrounding_character(inactive_character)
  end

  it "does not broadcast the enter message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    click_button character.name

    using_session(:distant_character) do
      expect(page).not_to have_css("#messages .message-enter-game")
    end
  end

  protected

  def have_surrounding_character(character)
    have_css("#surrounding-characters li", text: character.name)
  end
end
