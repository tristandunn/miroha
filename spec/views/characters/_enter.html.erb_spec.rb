# frozen_string_literal: true

require "rails_helper"

describe "characters/_enter.html.erb" do
  subject(:html) do
    render partial: "characters/enter", locals: { character: }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the character name and message" do
    expect(html).to have_command_row(
      "td[colspan=2]",
      text: t("characters.enter.message", name: character.name)
    )
  end
end
