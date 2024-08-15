# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/remove/success.html.erb" do
  subject(:html) do
    render partial: "commands/alias/remove/success", locals: { name: name }

    rendered
  end

  let(:name) { "/a" }

  it "renders the message" do
    expect(html).to have_css(
      "td:nth-child(2)",
      text: t("commands.alias.remove.success.message", name: name)
    )
  end
end
