# frozen_string_literal: true

require "rails_helper"

describe "Inactive characters", :clock, :js do
  let(:character) { create(:character) }

  before do
    sign_in_as_character character

    character.update(active_at: (Character::ACTIVE_DURATION + 1.minute).ago)
  end

  it "signs out inactive character" do
    run("Sign out inactive characters.")

    expect(page).to have_css("h1", text: t("characters.index.header"))
  end

  it "broadcasts an exit message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    run("Sign out inactive characters.")

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

    run("Sign out inactive characters.")

    using_session(:nearby_character) do
      expect(page).not_to have_surrounding_character(character)
    end
  end

  it "does not broadcast the exit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    run("Sign out inactive characters.")

    using_session(:distant_character) do
      expect(page).to have_no_css("#messages .message-exit-game")
    end
  end
end
