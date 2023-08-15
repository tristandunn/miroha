# frozen_string_literal: true

require "rails_helper"

describe "commands/direct/_missing_target.html.erb" do
  subject(:html) do
    render(
      partial: "commands/direct/missing_target",
      locals:  { target_name: target_name }
    )

    rendered
  end

  let(:target_name) { generate(:name) }

  it "renders the missing target message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.direct.missing_target.message", target_name: target_name)
    )
  end
end
