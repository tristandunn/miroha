# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/attacker/_unknown.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/attacker/unknown",
      locals:  {
        target_name: target_name
      }
    )

    rendered
  end

  context "with a target name" do
    let(:target_name) { generate(:name) }

    it "renders the invalid message" do
      expect(html).to have_command_row(
        "td[colspan=2]",
        text: t("commands.attack.attacker.unknown.invalid", target_name: target_name)
      )
    end
  end

  context "without a target name" do
    let(:target_name) { " " }

    it "renders the missing message" do
      expect(html).to have_command_row(
        "td[colspan=2]",
        text: t("commands.attack.attacker.unknown.missing")
      )
    end
  end
end
