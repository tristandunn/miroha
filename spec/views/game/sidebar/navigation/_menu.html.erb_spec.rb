# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/navigation/_menu.html.erb", type: :view do
  subject(:html) do
    render partial: "game/sidebar/navigation/menu"

    rendered
  end

  it "renders the equipment button" do
    expect(html).to have_css(
      %(a[title="#{t("game.sidebar.navigation.menu.equipment")}"])
    )
  end

  it "renders a form to exit the game" do
    expect(html).to have_css(
      %(form[action="#{exit_characters_path}"][method="post"])
    )
  end

  it "renders a submit button" do
    expect(html).to have_css(%(button#exit_game[type="submit"]))
  end
end
