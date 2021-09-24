# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/_character.html.erb", type: :view do
  subject(:html) do
    render(
      partial: "game/sidebar/character",
      locals:  { character: character }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the character name" do
    expect(html).to have_css("h1", text: character.name)
  end

  it "renders the experience" do
    width = "#{character.experience.remaining_percentage}%"
    title = t(
      "game.sidebar.character.experience",
      remaining: number_with_delimiter(character.experience.remaining)
    )

    expect(html).to have_css(%(div[title="#{title}"] div[style="width: #{width};"]))
  end

  it "renders the level" do
    expect(html).to have_css(
      "h2",
      text: t("game.sidebar.character.level", level: character.level)
    )
  end

  it "renders the health points" do
    expect(html).to have_css(%(div[title="8 / 10"] div[style="width: 80%;"]))
  end

  it "renders the magic points" do
    expect(html).to have_css(%(div[title="6 / 10"] div[style="width: 60%;"]))
  end
end
