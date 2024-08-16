# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/add/_invalid_command.html.erb" do
  subject(:html) do
    render partial: "commands/alias/add/invalid_command",
           locals:  { command: command }

    rendered
  end

  let(:command) { "/unknown" }

  it "renders the unknown alias message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.alias.add.invalid_command.message", command: command)
    )
  end
end
