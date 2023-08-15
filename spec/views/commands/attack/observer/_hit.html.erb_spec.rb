# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/observer/_hit.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/observer/hit",
      locals:  {
        character:   character,
        target_name: target_name
      }
    )

    rendered
  end

  let(:character)   { build_stubbed(:character) }
  let(:target_name) { generate(:name) }

  it "renders the hit message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t(
        "commands.attack.observer.hit.message",
        attacker_name: character.name,
        target_name:   target_name
      )
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
