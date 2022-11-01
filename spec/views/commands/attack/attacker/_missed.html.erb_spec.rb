# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/attacker/_missed.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/attacker/missed",
      locals:  {
        target_name: target_name
      }
    )

    rendered
  end

  let(:target_name) { generate(:name) }

  it "renders the missed message" do
    expect(html).to have_command_row(
      "td",
      text: t("commands.attack.attacker.missed.message", target_name: target_name)
    )
  end
end
