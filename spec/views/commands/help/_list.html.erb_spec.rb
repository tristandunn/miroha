# frozen_string_literal: true

require "rails_helper"

describe "commands/help/_list.html.erb" do
  subject(:html) do
    render partial: "commands/help/list", locals: { commands: [command] }

    rendered
  end

  let(:command) do
    {
      arguments:   "[argument]",
      description: "description",
      name:        "command"
    }
  end

  it "renders the headers" do
    expect(html).to have_css(
      ".message-help th[colspan=2]",
      text: t("commands.help.list.command")
    ).and(
      have_css(
        ".message-help th",
        text: t("commands.help.list.description")
      )
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
