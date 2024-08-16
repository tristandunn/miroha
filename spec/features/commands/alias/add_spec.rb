# frozen_string_literal: true

require "rails_helper"

describe "Sending the alias add command", :js do
  let(:character) { create(:character) }
  let(:command)   { "/alias add #{shortcut} #{name}" }
  let(:name)      { "/emote" }
  let(:shortcut)  { "/e" }

  before do
    sign_in_as_character character
  end

  it "displays the alias add command message to the sender" do
    send_text(command)

    expect(page).to have_alias_add_command_message(command: name, shortcut: shortcut)
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_text(command)

    wait_for(have_alias_add_command_message(command: name, shortcut: shortcut)) do
      using_session(:nearby_character) do
        expect(page).not_to have_alias_add_command_message(command: name, shortcut: shortcut)
      end
    end
  end

  context "with an invalid command" do
    let(:command) { "/alias add /f #{name}" }
    let(:name)    { "/fake" }

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

  def have_alias_add_command_message(command:, shortcut:)
    have_css(
      "#messages .message-alias-add",
      text: t("commands.alias.add.success.message", command: command, shortcut: shortcut)
    )
  end

  def have_invalid_command_message(command:)
    have_css(
      "#messages .message-alias-add-invalid-command",
      text: t("commands.alias.add.invalid_command.message", command: command)
    )
  end
end
