# frozen_string_literal: true

require "rails_helper"

describe "Sending an unknown command", type: :feature, js: true do
  let(:bob)  { create(:character, room: room) }
  let(:room) { create(:room) }
  let(:sue)  { create(:character, room: room) }

  before do
    sign_in_as_character bob
  end

  it "displays the unknown command message to the sender" do
    send_text("/fake command")

    expect(page).to have_unknown_command_message("/fake command")
  end

  it "does not broadcast the message to the room" do
    using_session(sue) do
      sign_in_as_character sue
    end

    send_text("/fake command")

    using_session(sue) do
      expect(page).not_to have_unknown_command_message("/fake command")
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
