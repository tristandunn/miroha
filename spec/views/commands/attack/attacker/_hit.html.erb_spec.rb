# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/attacker/_hit.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/attacker/hit",
      locals:  {
        damage:      damage,
        target_name: target_name
      }
    )

    rendered
  end

  let(:damage)      { rand(1..10) }
  let(:target_name) { generate(:name) }

  it "renders the hit message" do
    expect(html).to have_message_row(
      "td",
      text: t("commands.attack.attacker.hit.message", target_name: target_name, count: damage)
    )
  end
end
