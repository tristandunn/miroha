# frozen_string_literal: true

require "rails_helper"

describe "commands/help/_invalid_command.html.erb" do
  subject(:html) do
    render partial: "commands/help/invalid_command",
           locals:  { name: name }

    rendered
  end

  let(:name) { "fake" }

  it "renders the invalid command message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.help.invalid_command.message", name: name)
    )
  end
end
