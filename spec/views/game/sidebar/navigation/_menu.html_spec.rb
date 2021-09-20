# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/navigation/_menu.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  it "renders the equipment button" do
    expect(html).to have_css(
      %(a[title="#{t("game.sidebar.navigation.menu.equipment")}"])
    )
  end
end
