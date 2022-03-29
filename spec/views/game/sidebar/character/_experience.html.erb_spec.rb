# frozen_string_literal: true

require "rails_helper"

describe "game/sidebar/character/_experience.html.erb", type: :view do
  subject(:html) do
    render(
      partial: "game/sidebar/character/experience",
      locals:  { character: character }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the experience" do
    width = "#{character.experience.remaining_percentage}%"
    title = t(
      "game.sidebar.character.experience.title",
      remaining: number_with_delimiter(character.experience.remaining)
    )

    expect(html).to have_css(
      %(div[title="#{title}"] div[style="width: #{width};"]),
      text: "#{character.experience.current} / #{character.experience.needed}"
    )
  end
end
