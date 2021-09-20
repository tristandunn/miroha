# frozen_string_literal: true

require "rails_helper"

describe "game/_surroundings.html.erb", type: :view do
  subject(:html) do
    render partial: "game/surroundings"

    rendered
  end

  it "renders the surroundings" do
    expect(html).to have_css("#surroundings")
  end
end
