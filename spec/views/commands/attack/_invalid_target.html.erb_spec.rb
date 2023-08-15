# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_invalid_target.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/invalid_target",
      locals:  {
        target_name: target_name
      }
    )

    rendered
  end

  let(:target_name) { generate(:name) }

  it "renders the invalid message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.attack.invalid_target.message", target_name: target_name)
    )
  end
end
