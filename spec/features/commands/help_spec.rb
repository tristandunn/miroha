# frozen_string_literal: true

require "rails_helper"

describe "Sending the help command", :js do
  let(:character) { create(:character) }
  let(:command)   { "/help" }

  before do
    sign_in_as_character character
  end

  it "displays the help command message to the sender" do
    send_text(command)

    expect(page).to have_help_command_message
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_text(command)

    wait_for(have_help_command_message) do
      using_session(:nearby_character) do
        expect(page).not_to have_help_command_message
      end
    end
  end

  context "with a valid command" do
    let(:command) { "/help /#{name}" }
    let(:name)    { "alias" }

    it "displays the help command message to the sender" do
      send_text(command)

      expect(page).to have_help_command_message
    end

    it "does not broadcast the message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_text(command)

      wait_for(have_help_command_message) do
        using_session(:nearby_character) do
          expect(page).not_to have_help_command_message
        end
      end
    end
  end

  context "with an invalid command" do
    let(:command) { "/help /#{name}" }
    let(:name)    { "fake" }

    it "displays invalid command message to the sender" do
      send_text(command)

      expect(page).to have_invalid_command_message(command: name)
    end

    it "does not broadcast the message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_text(command)

      wait_for(have_invalid_command_message(command: name)) do
        using_session(:nearby_character) do
          expect(page).not_to have_invalid_command_message(command: name)
        end
      end
    end
  end

  protected

  def have_help_command_message
    have_css("#messages .message-help")
  end

  def have_invalid_command_message(command:)
    have_css(
      "#messages .message-help-invalid-command",
      text: t("commands.help.invalid_command.message", name: command)
    )
  end
end
