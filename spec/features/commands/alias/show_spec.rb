# frozen_string_literal: true

require "rails_helper"

describe "Sending the alias show command", :js do
  let(:character) { create(:character) }
  let(:command)   { "/alias show u" }

  before do
    sign_in_as_character character
  end

  it "displays the alias show command message to the sender" do
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

  context "with an unknown alias" do
    let(:command) { "/alias show #{name}" }
    let(:name)    { "unknown" }

    it "displays unknown alias message to the sender" do
      send_text(command)

      expect(page).to have_unknown_alias_message(name: name)
    end

    it "does not broadcast the message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_text(command)

      wait_for(have_unknown_alias_message(name: name)) do
        using_session(:nearby_character) do
          expect(page).not_to have_unknown_alias_message(name: name)
        end
      end
    end
  end

  protected

  def have_alias_command_message
    have_css("#messages .message-alias")
  end

  def have_unknown_alias_message(name:)
    have_css(
      "#messages .message-alias-unknown",
      text: t("commands.alias.show.unknown_alias.message", name: name)
    )
  end
end
