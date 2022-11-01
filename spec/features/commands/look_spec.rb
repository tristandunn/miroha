# frozen_string_literal: true

require "rails_helper"

describe "Sending the look command", js: true do
  let(:character) { create(:character) }
  let(:room)      { character.room }

  before do
    sign_in_as_character character
  end

  it "displays the look message to the sender" do
    send_command(:look)

    expect(page).to have_look_message(room, count: 2)
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:look)

    wait_for(have_look_message(room, count: 2)) do
      using_session(:nearby_character) do
        expect(page).not_to have_look_message(room, count: 2)
      end
    end
  end
end
