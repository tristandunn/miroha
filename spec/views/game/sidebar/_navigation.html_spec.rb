# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/_navigation.html.erb", type: :view do
  subject(:html) do
    render partial: "game/sidebar/navigation"

    rendered
  end

  before do
    stub_template(
      "game/sidebar/navigation/_menu.html.erb"    => "<p>Menu</p>",
      "game/sidebar/navigation/_content.html.erb" => "<p>Content</p>"
    )
  end

  it "renders the menu" do
    expect(html).to have_css("#navigation p", text: "Menu")
  end

  it "renders the content" do
    expect(html).to have_css("#navigation p", text: "Content")
  end
end
