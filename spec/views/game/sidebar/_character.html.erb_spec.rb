# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/_character.html.erb" do
  subject(:html) do
    render(
      partial: "game/sidebar/character",
      locals:  { character: character }
    )

    rendered
  end

  let(:character) { build_stubbed(:character, current_health: 1_337, maximum_health: 31_337) }

  before do
    stub_template(
      "game/sidebar/character/_experience.html.erb" => "EXPERIENCE_TEMPLATE"
    )
  end

  it "renders the character name" do
    expect(html).to have_css("h1", text: character.name)
  end

  it "renders the experience template" do
    expect(html).to have_content("EXPERIENCE_TEMPLATE")
  end

  it "renders the level" do
    expect(html).to have_css(
      "h2",
      text: t("game.sidebar.character.level", level: character.level)
    )
  end

  it "renders the health points" do
    width = "#{character.health.remaining_percentage}%"
    title = [
      number_with_delimiter(character.health.current),
      number_with_delimiter(character.health.maximum)
    ].join(" / ")

    expect(html).to have_css(
      %(div[title="#{title}"] div[style="width: #{width};"])
    )
  end

  it "renders the magic points" do
    expect(html).to have_css(%(div[title="6 / 10"] div[style="width: 60%;"]))
  end
end
