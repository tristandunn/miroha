# frozen_string_literal: true

require "rails_helper"

describe "layouts/game.html.erb" do
  subject(:html) do
    render template: "layouts/game"

    rendered
  end

  it "renders the page title" do
    expect(html).to have_title(t("title"))
  end
end
