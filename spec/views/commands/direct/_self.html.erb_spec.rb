# frozen_string_literal: true

require "rails_helper"

describe "commands/direct/_self.html.erb" do
  subject(:html) do
    render partial: "commands/direct/self"

    rendered
  end

  it "renders the self message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.direct.self.message")
    )
  end
end
