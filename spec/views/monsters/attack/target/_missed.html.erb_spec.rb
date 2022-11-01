# frozen_string_literal: true

require "rails_helper"

describe "monsters/attack/target/_missed.html.erb" do
  subject(:html) do
    render(
      partial: "monsters/attack/target/missed",
      locals:  { attacker_name: attacker_name }
    )

    rendered
  end

  let(:attacker_name) { generate(:name) }

  it "renders the target hit message" do
    expect(html).to have_command_row(
      "td:nth-child(2)",
      text: t("monsters.attack.target.missed.message", attacker_name: attacker_name)
    )
  end
end
