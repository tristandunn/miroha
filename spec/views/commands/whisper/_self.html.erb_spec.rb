# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_self.html.erb" do
  subject(:html) do
    render partial: "commands/whisper/self"

    rendered
  end

  it "renders the self message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.whisper.self.message")
    )
  end
end
