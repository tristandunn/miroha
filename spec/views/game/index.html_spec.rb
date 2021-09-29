# frozen_string_literal: true

require "rails_helper"

describe "game/index.html.erb", type: :view do
  subject(:html) do
    render template: "game/index"

    rendered
  end

  let(:character) { build_stubbed(:character) }

  before do
    assign :character, character

    stub_template(
      "game/_chat.html.erb"         => "<p>Chat</p>",
      "game/_sidebar.html.erb"      => "<p>Sidebar</p>",
      "game/_surroundings.html.erb" => "<p>Surroundings</p>",
      "game/_streams.html.erb"      => "<p>Stream</p>"
    )
  end

  it "renders the game" do
    expect(html).to have_css(
      %(main[data-controller="game"][data-character-id="#{character.id}"])
    )
  end

  it "renders the sidebar" do
    expect(html).to have_css("#container p", text: "Sidebar")
  end

  it "renders the chat" do
    expect(html).to have_css("#container p", text: "Chat")
  end

  it "renders the surroundings" do
    expect(html).to have_css("#container p", text: "Surroundings")
  end

  it "renders the streams" do
    expect(html).to have_css("p", text: "Stream")
  end
end
