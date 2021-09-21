# frozen_string_literal: true

require "rails_helper"

describe "commands/_unknown.html.erb", type: :view do
  subject(:html) do
    render partial: "commands/unknown", locals: { command: command }

    rendered
  end

  let(:command) { "/unknown command" }

  it "renders the unknown command message" do
    expect(html).to have_command_row(
      "td:nth-child(2)",
      text: t("commands.unknown.message", command: command)
    )
  end
end
