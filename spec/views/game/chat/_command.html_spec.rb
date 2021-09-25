# frozen_string_literal: true

require "rails_helper"

describe "game/chat/_command.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  it "renders a Turbo frame" do
    expect(html).to have_css(%(turbo-frame[id="command"]))
  end

  it "renders the command form" do
    actions = "submit->chat#aliasCommand " \
              "submit->chat#validateCommand " \
              "turbo:submit-end->chat#handleRedirect " \
              "turbo:submit-end->chat#resetForm"

    expect(html).to have_css(
      %(form[action="#{commands_path}"][data-controller="chat"][data-action="#{actions}"])
    )
  end

  it "renders the command input" do
    expect(html).to have_css(%(input[autofocus][name="input"][spellcheck="false"]))
  end
end
