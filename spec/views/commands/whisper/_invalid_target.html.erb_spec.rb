# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_invalid_target.html.erb" do
  subject(:html) do
    render partial: "commands/whisper/invalid_target"

    rendered
  end

  it "renders the self message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.whisper.invalid_target.message")
    )
  end
end
