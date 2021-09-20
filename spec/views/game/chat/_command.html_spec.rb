# frozen_string_literal: true

require "rails_helper"

describe "game/chat/_command.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  it "renders the command input" do
    expect(html).to have_css(%(input[autofocus][name="input"][spellcheck="false"]))
  end
end
