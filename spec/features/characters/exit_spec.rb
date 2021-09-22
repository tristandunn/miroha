# frozen_string_literal: true

require "rails_helper"

describe "Character exiting the game", type: :feature, js: true do
  let(:character) { create(:character) }

  before do
    sign_in_as_character character
  end

  it "successfully" do
    click_button "exit_game"

    expect(page).to have_css("h1", text: t("characters.index.header"))
  end

  it "broadcasts an exit message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    click_button "exit_game"

    using_session(:nearby_character) do
      expect(page).to have_css(
        "#messages .message-exit-game",
        text: t("characters.exit.message", name: character.name)
      )
    end
  end

  it "does not broadcast the exit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    click_button "exit_game"

    using_session(:distant_character) do
      expect(page).not_to have_css("#messages .message-exit-game")
    end
  end
end
