# frozen_string_literal: true

require "rails_helper"

describe "game/surroundings/_character.html.erb", type: :view do
  subject(:html) do
    render template: "game/surroundings/_character",
           locals:   { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the surrounding character" do
    expect(html).to have_css("#surrounding_character_#{character.id}", text: character.name)
  end
end
