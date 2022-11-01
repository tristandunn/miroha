# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_failure.html.erb" do
  subject(:html) do
    render(
      partial: "commands/move/failure",
      locals:  {
        direction: direction
      }
    )

    rendered
  end

  let(:direction) { :north }

  it "renders the failure message with the direction" do
    expect(html).to have_command_row(
      "td:nth-child(2)",
      text: t("commands.move.failure.message", direction: direction)
    )
  end
end
