# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_exit.html.erb" do
  subject(:html) do
    render(
      partial: "commands/move/exit",
      locals:  {
        character: character,
        direction: direction
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:direction) { :north }

  it "renders the exit message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.move.exit.#{direction}", name: character.name)
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
