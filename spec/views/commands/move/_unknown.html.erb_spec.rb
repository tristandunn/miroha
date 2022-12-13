# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_unknown.html.erb" do
  subject(:html) do
    render partial: "commands/move/unknown"

    rendered
  end

  it "renders the unknown message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.move.unknown.message")
    )
  end
end
