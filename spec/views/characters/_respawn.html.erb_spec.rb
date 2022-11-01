# frozen_string_literal: true

require "rails_helper"

describe "characters/_respawn.html.erb" do
  subject(:html) do
    render(
      partial: "characters/respawn",
      locals:  { character: character }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the respawn message" do
    expect(html).to have_command_row(
      "td:nth-child(2)",
      text: t("characters.respawn.message", name: character.name)
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
