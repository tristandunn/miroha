# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/list/success.html.erb" do
  subject(:html) do
    render partial: "commands/alias/list/success", locals: { aliases: aliases }

    rendered
  end

  let(:aliases) do
    {
      "o" => "/other",
      "t" => "/test"
    }
  end

  it "renders the header" do
    expect(html).to have_css(
      ".message-alias td[colspan=2]",
      text: t("commands.alias.list.success.header")
    )
  end

  it "renders the alias names" do
    expect(html).to have_message_row("td[colspan=2] tr td:nth-child(1)", text: "t")
      .and(have_message_row("td[colspan=2] tr td:nth-child(1)", text: "o"))
  end

  it "renders the alias commands" do
    expect(html).to have_message_row("td[colspan=2] tr td:nth-child(2)", text: "/test")
      .and(have_message_row("td[colspan=2] tr td:nth-child(2)", text: "/other"))
  end
end
