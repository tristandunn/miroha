# frozen_string_literal: true

require "rails_helper"

describe "Sending an unknown command", type: :feature, js: true do
  let(:character) { create(:character) }
  let(:command)   { "/fake command" }

  before do
    sign_in_as_character character
  end

  it "displays the unknown command message to the sender" do
    send_text(command)

    expect(page).to have_unknown_command_message(command)
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_text(command)

    using_session(:nearby_character) do
      expect(page).not_to have_unknown_command_message(command)
    end
  end

  protected

  def have_unknown_command_message(command)
    have_css(
      "#messages .message-unknown",
      text: t("commands.unknown.message", command: command)
    )
  end
end
