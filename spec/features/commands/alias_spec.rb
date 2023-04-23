# frozen_string_literal: true

require "rails_helper"

describe "Sending the alias command", js: true do
  let(:character) { create(:character) }
  let(:command)   { "/alias" }

  before do
    sign_in_as_character character
  end

  it "displays the alias command message to the sender" do
    send_text(command)

    expect(page).to have_alias_command_message
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_text(command)

    wait_for(have_alias_command_message) do
      using_session(:nearby_character) do
        expect(page).not_to have_alias_command_message
      end
    end
  end

  protected

  def have_alias_command_message
    have_css("#messages .message-alias")
  end
end
