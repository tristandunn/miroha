# frozen_string_literal: true

require "rails_helper"

describe "game/chat/_messages.html.erb", type: :view do
  subject(:html) do
    render partial: "game/chat/messages"

    rendered
  end

  it "renders the messages table" do
    expect(html).to have_css("table tbody#messages")
  end
end
