# frozen_string_literal: true

require "rails_helper"

describe "Sending the direct command", type: :feature, js: true do
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

    send_command(:direct, nearby_character.name, message)

    expect(page).to have_direct(message, from: character, to: nearby_character)
  end

  it "broadcasts the message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character nearby_character
    end

    send_command(:direct, nearby_character.name, message)

    using_session(:nearby_character) do
      expect(page).to have_direct(message, from: character, to: nearby_character)
    end
  end

  it "does not broadcast the message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character
    end

    send_command(:direct, nearby_character.name, message)

    using_session(:distant_character) do
      expect(page).not_to have_css("#messages .message-direct")
    end
  end

  context "when using the /d alias" do
    it "displays the message to the sender" do
      send_command(:d, nearby_character.name, message)

      expect(page).to have_direct(message, from: character, to: nearby_character)
    end
  end

  protected

  def have_direct(message, from:, to:)
    have_css(
      "#messages .message-direct:nth-child(1)",
      text: from.name
    ).and(
      have_css(
        "#messages .message-direct:nth-child(2)",
        text: "#{to.name}: #{message}"
      )
    )
  end
end
