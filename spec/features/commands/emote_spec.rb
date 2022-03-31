# frozen_string_literal: true

require "rails_helper"

describe "Sending the emote command", type: :feature, js: true do
  let(:character) { create(:character) }
  let(:message)   { Faker::Lorem.sentence }

  before do
    sign_in_as_character character
  end

  it "displays the message to the sender" do
    send_command(:emote, message)

    expect(page).to have_emote(message, from: character)
  end

  it "broadcasts the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:emote, message)

    using_session(:nearby_character) do
      expect(page).to have_emote(message, from: character)
    end
  end

  it "does not broadcast the message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    send_command(:emote, message)

    wait_for(have_emote(message, from: character)) do
      using_session(:distant_character) do
        expect(page).not_to have_css("#messages .message-emote")
      end
    end
  end

  context "when using the /me alias" do
    it "displays the message to the sender" do
      send_command(:me, message)

      expect(page).to have_emote(message, from: character)
    end
  end

  protected

  def have_emote(text, from:)
    have_css("#messages .message-emote", text: "#{from.name} #{text}")
  end
end
