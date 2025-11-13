# frozen_string_literal: true

require "rails_helper"

describe "commands/use/_not_consumable.html.erb" do
  subject(:html) do
    render(
      partial: "commands/use/not_consumable",
      locals:  {
        item: item
      }
    )

    rendered
  end

  let(:item) { build_stubbed(:item) }

  it "renders the not consumable message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.use.not_consumable.message", name: item.name)
    )
  end
end
