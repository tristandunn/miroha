# frozen_string_literal: true

require "rails_helper"

describe "monsters/attack/_missed.html.erb" do
  subject(:html) do
    render(
      partial: "monsters/attack/missed",
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

  it "renders the miss message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("monsters.attack.missed.message",
              attacker_name: attacker_name,
              target_name:   target_name)
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
