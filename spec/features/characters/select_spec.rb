# frozen_string_literal: true

require "rails_helper"

describe "Selecting a character", type: :feature, js: true do
  let(:character) { create(:character) }

  before do
    sign_in_as character.account
  end

  it "successfully" do
    click_button character.name

    expect(page).to have_css("#sidebar h1", text: character.name)
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

  it "does not broadcast the enter message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    click_button character.name

    using_session(:distant_character) do
      expect(page).not_to have_css("#messages .message-enter-game")
    end
  end
end
