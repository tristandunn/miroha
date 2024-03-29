# frozen_string_literal: true

require "rails_helper"

describe "Character exiting the game", :js do
  let(:character) { create(:character) }

  before do
    sign_in_as_character character
  end

  it "successfully" do
    click_on "exit_game"

    expect(page).to have_css("h1", text: t("characters.index.header"))
  end

  it "broadcasts an exit message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    click_on "exit_game"

    using_session(:nearby_character) do
      expect(page).to have_css(
        "#messages .message-exit-game",
        text: t("characters.exit.message", name: character.name)
      )
    end
  end

  it "removes the character from the surroundings" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    click_on "exit_game"

    using_session(:nearby_character) do
      expect(page).not_to have_surrounding_character(character)
    end
  end

  it "does not broadcast the exit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    click_on "exit_game"

    using_session(:distant_character) do
      expect(page).to have_no_css("#messages .message-exit-game")
    end
  end
end
