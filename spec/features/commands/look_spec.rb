# frozen_string_literal: true

require "rails_helper"

describe "Sending the look command", js: true do
  let(:character) { create(:character, room: room) }
  let(:room)      { create(:room, objects: { "rock" => "It's a rock." }) }

  before do
    sign_in_as_character character
  end

  context "with no object" do
    it "displays the room description to the sender" do
      send_command(:look)

      expect(page).to have_look_message(room.description, count: 2)
    end
  end

  context "with an object" do
    it "displays the room description to the sender" do
      send_command(:look, :rock)

      expect(page).to have_look_message("It's a rock.")
    end
  end

  context "with invalid object" do
    it "displays the room description to the sender" do
      send_command(:look, :scissors)

      expect(page).to have_look_message(
        t("commands.look.unknown", article: "a", target: "scissors")
      )
    end
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:look)

    wait_for(have_look_message(room.description, count: 2)) do
      using_session(:nearby_character) do
        expect(page).not_to have_look_message(room.description, count: 2)
      end
    end
  end
end
