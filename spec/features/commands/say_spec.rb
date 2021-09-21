# frozen_string_literal: true

require "rails_helper"

describe "Sending the say command", type: :feature, js: true do
  let(:bob)     { create(:character, room: room) }
  let(:message) { "Hello, world!" }
  let(:room)    { create(:room) }
  let(:sue)     { create(:character, room: room) }
  let(:tom)     { create(:character) }

  before do
    sign_in_as_character bob
  end

  it "displays the message to the sender" do
    send_command(:say, message)

    expect(page).to have_message(message, from: bob)
  end

  it "broadcasts the message to the room" do
    using_session(sue) do
      sign_in_as_character sue
    end

    send_command(:say, message)

    using_session(sue) do
      expect(page).to have_message(message, from: bob)
    end
  end

  it "does not broadcast the message to other rooms" do
    send_command(:say, message)

    using_session(tom) do
      expect(page).not_to have_css("#messages .message-say")
    end
  end

  it "does not allow blank messages" do
    send_text("")

    expect(page).not_to have_css("#messages tr")
  end

  protected

  def have_message(text, from:)
    have_css("#messages .message-say", text: from.name).and(
      have_css("#messages .message-say", text: text)
    )
  end
end
