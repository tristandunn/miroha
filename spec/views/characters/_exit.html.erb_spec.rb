# frozen_string_literal: true

require "rails_helper"

describe "characters/_exit.html.erb" do
  subject(:html) do
    render partial: "characters/exit", locals: { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the character name and message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("characters.exit.message", name: character.name)
    )
  end
end
