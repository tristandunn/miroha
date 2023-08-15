# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/observer/_killed.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/observer/killed",
      locals:  {
        character:   character,
        target_name: target_name
      }
    )

    rendered
  end

  let(:character)   { build_stubbed(:character) }
  let(:target_name) { generate(:name) }

  it "renders the killed message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t(
        "commands.attack.observer.killed.message",
        attacker_name: character.name,
        target_name:   target_name
      )
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
