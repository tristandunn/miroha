# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_missing_target.html.erb" do
  subject(:html) do
    render(partial: "commands/attack/missing_target")

    rendered
  end

  it "renders the missing message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.attack.missing_target.message")
    )
  end
end
