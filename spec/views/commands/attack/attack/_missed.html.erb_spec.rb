# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/attack/_missed.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/attack/missed",
      locals:  {
        attacker_name: attacker_name,
        character:     character,
        target_name:   target_name
      }
    )

    rendered
  end

  let(:attacker_name) { character.name }
  let(:character)     { build_stubbed(:character) }
  let(:target_name)   { generate(:name) }

  it "renders the missed message" do
    expect(html).to have_command_row(
      %(td[data-character-id="#{character.id}"]),
      text: t(
        "commands.attack.attack.missed.message",
        attacker_name: attacker_name,
        target_name:   target_name
      )
    )
  end
end
