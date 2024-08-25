# frozen_string_literal: true

require "rails_helper"

describe "game/surroundings/_item.html.erb" do
  subject(:html) do
    render template: "game/surroundings/_item",
           locals:   { item: item }

    rendered
  end

  let(:item) { build_stubbed(:item) }

  it "renders the surrounding item" do
    expect(html).to have_css("#surrounding_item_#{item.id}", text: item.name)
  end
end
