# frozen_string_literal: true

require "rails_helper"

describe "game/_chat.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  before do
    stub_template(
      "game/chat/_messages.html.erb" => "<p>Messages</p>",
      "game/chat/_command.html.erb"  => "<p>Command</p>"
    )
  end

  it "renders the messages" do
    expect(html).to have_css("#chat p", text: "Messages")
  end

  it "renders the command" do
    expect(html).to have_css("#chat p", text: "Command")
  end
end
