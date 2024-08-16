# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/add/success.html.erb" do
  subject(:html) do
    render partial: "commands/alias/add/success", locals: {
      account:  account,
      command:  command,
      shortcut: shortcut
    }

    rendered
  end

  let(:account)  { build_stubbed(:account) }
  let(:command)  { "/emote" }
  let(:shortcut) { "/e" }

  it "renders the message" do
    expect(html).to have_css(
      "td:nth-child(2)",
      text: t("commands.alias.add.success.message", command: command, shortcut: shortcut)
    )
  end

  it "overwrites the local alias cache" do
    expect(html).to include(
      "<script>window.Miroha.Settings.aliases = #{account.aliases.to_json};</script>"
    )
  end
end
