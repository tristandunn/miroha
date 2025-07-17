# frozen_string_literal: true

require "rails_helper"

describe "commands/pickup/_missing_item.html.erb" do
  subject(:html) do
    render(partial: "commands/pickup/missing_item")

    rendered
  end

  it "renders the missing item message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.pickup.missing_item.message")
    )
  end
end
