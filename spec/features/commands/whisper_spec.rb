# frozen_string_literal: true

require "rails_helper"

describe "Sending the whisper command", type: :feature, js: true do
  let(:character)        { create(:character) }
  let(:message)          { Faker::Lorem.sentence }
  let(:nearby_character) { create(:character, room: character.room) }

  before do
    sign_in_as_character character
  end

  it "displays the message to the sender" do
    using_session(:nearby_character) do
      sign_in_as_character nearby_character
    end

    send_command(:whisper, nearby_character.name, message)

    expect(page).to have_source_whisper(message, from: character, to: nearby_character)
  end

  it "displays the message to the target" do
    using_session(:nearby_character) do
      sign_in_as_character nearby_character
    end

    send_command(:whisper, nearby_character.name, message)

    using_session(:nearby_character) do
      expect(page).to have_target_whisper(message, from: character)
    end
  end

  it "does not broadcast the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character nearby_character
    end

    send_command(:whisper, nearby_character.name, message)

    using_session(:nearby_character) do
      expect(page).not_to have_css("#messages .message-whisper")
    end
  end

  it "does not broadcast the message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    send_command(:whisper, nearby_character.name, message)

    using_session(:distant_character) do
      expect(page).not_to have_css("#messages .message-whisper")
    end
  end

  protected

  def have_source_whisper(message, from:, to: nil)
    have_css(
      "#messages .message-whisper",
      text: strip_tags(
        t("commands.whisper.source.message_html",
          message: message, name: from.name, target_name: to.name)
      )
    )
  end

  def have_target_whisper(message, from:)
    have_css(
      "#messages .message-whisper",
      text: strip_tags(
        t("commands.whisper.target.message_html", message: message, name: from.name)
      )
    )
  end
end
