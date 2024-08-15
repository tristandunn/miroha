# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/remove/_unknown_alias.html.erb" do
  subject(:html) do
    render partial: "commands/alias/remove/unknown_alias",
           locals:  { name: name }

    rendered
  end

  let(:name) { "unknown" }

  it "renders the unknown alias message" do
    expect(html).to have_message_row(
      "td:nth-child(2)",
      text: t("commands.alias.remove.unknown_alias.message", name: name)
    )
  end
end
