# frozen_string_literal: true

require "rails_helper"

describe "commands/use/_invalid_item.html.erb" do
  subject(:html) do
    render(
      partial: "commands/use/invalid_item",
      locals:  {
        name: name
      }
    )

    rendered
  end

  let(:name) { generate(:name) }

  it "renders the invalid item message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.use.invalid_item.message", name: name)
    )
  end
end
