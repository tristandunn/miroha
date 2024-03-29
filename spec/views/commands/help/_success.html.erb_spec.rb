# frozen_string_literal: true

require "rails_helper"

describe "commands/help/_success.html.erb" do
  subject(:html) do
    render partial: "commands/help/success", locals: { commands: [command] }

    rendered
  end

  let(:command) do
    {
      arguments:   "[argument]",
      description: "description",
      name:        "command"
    }
  end

  it "renders the header" do
    expect(html).to have_css(
      ".message-help td[colspan=3]",
      text: t("commands.help.success.header")
    )
  end

  it "renders the command name" do
    expect(html).to have_message_row(
      "td[colspan=2] td:nth-child(1)",
      text: "/command"
    )
  end

  it "renders the command arguments" do
    expect(html).to have_message_row(
      "td[colspan=2] td:nth-child(2)",
      text: "[argument]"
    )
  end

  it "renders the command description" do
    expect(html).to have_message_row(
      "td[colspan=2] td:nth-child(3)",
      text: "description"
    )
  end
end
