# frozen_string_literal: true

require "rails_helper"

describe "Sending the say command", type: :feature, js: true do
  let(:character) { create(:character) }
  let(:message)   { Faker::Lorem.sentence }

  before do
    sign_in_as_character character
  end

  it "displays the message to the sender" do
    send_command(:say, message)

    expect(page).to have_message(message, from: character)
  end

  it "broadcasts the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:say, message)

    using_session(:nearby_character) do
      expect(page).to have_message(message, from: character)
    end
  end

  it "does not broadcast the message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    send_command(:say, message)

    using_session(:distant_character) do
      expect(page).not_to have_css("#messages .message-say")
    end
  end

  it "does not allow blank messages" do
    send_text("")

    expect(page).not_to have_css("#messages .message-say")
  end

  protected

  def have_message(text, from:)
    have_css("#messages .message-say", text: from.name).and(
      have_css("#messages .message-say", text: text)
    )
  end
end
