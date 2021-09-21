# frozen_string_literal: true

require "rails_helper"

describe "game/chat/_messages.html.erb", type: :view do
  subject(:html) do
    render partial: "game/chat/messages"

    rendered
  end

  it "renders the messages table" do
    expect(html).to have_css(
      '[data-action="message-connected->chat#messageConnected"]' \
      '[data-chat-target="messages"] ' \
      "table tbody#messages"
    )
  end

  it "renders the unread messages indicator" do
    expect(html).to have_css(
      '[data-chat-target="newMessages"] ' \
      'a[data-action="click->chat#scrollToBottom"]',
      text: t("game.chat.messages.unread")
    )
  end
end
