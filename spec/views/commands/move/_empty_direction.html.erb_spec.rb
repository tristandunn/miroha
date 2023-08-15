# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_empty_direction.html.erb" do
  subject(:html) do
    render(
      partial: "commands/move/empty_direction",
      locals:  {
        direction: direction
      }
    )

    rendered
  end

  let(:direction) { :north }

  it "renders the empty direction message with the direction" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.move.empty_direction.message", direction: direction)
    )
  end
end
