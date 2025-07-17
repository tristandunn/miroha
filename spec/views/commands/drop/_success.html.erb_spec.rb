# frozen_string_literal: true

require "rails_helper"

describe "commands/drop/_success.html.erb" do
  subject(:html) do
    render(
      partial: "commands/drop/success",
      locals:  {
        name: name
      }
    )

    rendered
  end

  let(:name) { generate(:name) }

  it "renders the success message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.drop.success.message", name: name)
    )
  end
end
