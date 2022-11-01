# frozen_string_literal: true

require "rails_helper"

describe "game/_sidebar.html.erb" do
  subject(:html) do
    render partial: "game/sidebar",
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  before do
    stub_template(
      "game/sidebar/_character.html.erb"  => "<p>Character</p>",
      "game/sidebar/_navigation.html.erb" => "<p>Navigation</p>"
    )
  end

  it "renders the character" do
    expect(html).to have_css("#sidebar p", text: "Character")
  end

  it "renders the navigation" do
    expect(html).to have_css("#sidebar p", text: "Navigation")
  end
end
