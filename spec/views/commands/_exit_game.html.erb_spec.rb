# frozen_string_literal: true

require "rails_helper"

describe "commands/_exit_game.html.erb" do
  subject(:html) do
    render partial: "commands/exit_game"

    rendered
  end

  it "renders the exit game element" do
    expect(html).to have_css(%([data-controller="exit-game"]))
  end
end
