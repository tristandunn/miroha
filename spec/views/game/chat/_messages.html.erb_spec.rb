# frozen_string_literal: true

require "rails_helper"

describe "game/chat/_messages.html.erb" do
  subject(:html) do
    render(
      partial: "game/chat/messages",
      locals:  { room: room }
    )

    rendered
  end

  let(:room) { build_stubbed(:room) }

  before do
    stub_template("commands/_look.html.erb" => "<p>Look</p>")
  end

  it "renders the messages table" do
    expect(html).to have_css(
      '[data-chat-target="messages"] ' \
      "table tbody#messages"
    )
  end

  it "renders the look command" do
    expect(html).to have_css("#messages", text: "Look")
  end

  it "renders the unread messages indicator" do
    expect(html).to have_css(
      '[data-chat-target="newMessages"] ' \
      'a[data-action="click->chat#scrollToBottom"]',
      text: t("game.chat.messages.unread")
    )
  end
end
