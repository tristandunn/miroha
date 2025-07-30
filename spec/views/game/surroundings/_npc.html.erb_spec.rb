# frozen_string_literal: true

require "rails_helper"

describe "game/surroundings/_npc.html.erb" do
  subject(:html) do
    render template: "game/surroundings/_npc",
           locals:   { npc: npc }

    rendered
  end

  let(:npc) { build_stubbed(:npc) }

  it "renders the surrounding NPC" do
    expect(html).to have_css("#surrounding_npc_#{npc.id}", text: npc.name)
  end
end
