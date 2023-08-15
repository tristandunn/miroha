# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_invalid_direction.html.erb" do
  subject(:html) do
    render partial: "commands/move/invalid_direction"

    rendered
  end

  it "renders the invalid direction message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.move.invalid_direction.message")
    )
  end
end
