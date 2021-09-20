# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/navigation/_content.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  it "renders the container" do
    expect(html).to have_css("div")
  end
end
