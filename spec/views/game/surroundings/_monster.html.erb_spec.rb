# frozen_string_literal: true

require "rails_helper"

describe "game/surroundings/_monster.html.erb" do
  subject(:html) do
    render template: "game/surroundings/_monster",
           locals:   { monster: monster }

    rendered
  end

  let(:monster) { build_stubbed(:monster) }

  it "renders the surrounding monster" do
    expect(html).to have_css("#surrounding_monster_#{monster.id}", text: monster.name)
  end
end
