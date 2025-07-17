# frozen_string_literal: true

require "rails_helper"

describe "commands/pickup/_success.html.erb" do
  subject(:html) do
    render(
      partial: "commands/pickup/success",
      locals:  {
        name: name
      }
    )

    rendered
  end

  let(:name) { generate(:name) }

  it "renders the success message" do
    expect(html).to have_message_row(
      "td",
      text: t("commands.pickup.success.message", name: name)
    )
  end
end
