# frozen_string_literal: true

require "rails_helper"

describe "characters/index.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  it "renders the header" do
    expect(html).to have_css("h1", text: t("characters.index.header"))
  end

  it "renders the empty message" do
    expect(html).to have_css("p", text: t("characters.index.empty"))
  end
end
