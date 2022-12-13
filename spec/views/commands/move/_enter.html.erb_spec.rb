# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_enter.html.erb" do
  subject(:html) do
    render(
      partial: "commands/move/enter",
      locals:  {
        character: character,
        direction: direction
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:direction) { :north }

  it "renders the enter message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.move.enter.#{direction}", name: character.name)
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
