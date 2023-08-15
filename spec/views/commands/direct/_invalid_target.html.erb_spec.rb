# frozen_string_literal: true

require "rails_helper"

describe "commands/direct/_invalid_target.html.erb" do
  subject(:html) do
    render partial: "commands/direct/invalid_target"

    rendered
  end

  it "renders the self message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.direct.invalid_target.message")
    )
  end
end
