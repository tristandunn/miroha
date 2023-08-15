# frozen_string_literal: true

require "rails_helper"

describe "commands/unknown/_success.html.erb" do
  subject(:html) do
    render partial: "commands/unknown/success", locals: { command: command }

    rendered
  end

  let(:command) { "/unknown command" }

  it "renders the unknown command message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.unknown.success.message", command: command)
    )
  end
end
