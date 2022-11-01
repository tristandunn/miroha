# frozen_string_literal: true

require "rails_helper"

describe "monsters/attack/target/_hit.html.erb" do
  subject(:html) do
    render(
      partial: "monsters/attack/target/hit",
      locals:  {
        attacker_name: attacker_name,
        damage:        damage
      }
    )

    rendered
  end

  let(:attacker_name) { generate(:name) }
  let(:damage)        { rand(1..10) }

  it "renders the target hit message" do
    expect(html).to have_command_row(
      "td:nth-child(2)",
      text: t("monsters.attack.target.hit.message",
              attacker_name: attacker_name,
              count:         damage)
    )
  end
end
