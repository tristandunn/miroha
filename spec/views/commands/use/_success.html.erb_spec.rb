# frozen_string_literal: true

require "rails_helper"

describe "commands/use/_success.html.erb" do
  subject(:html) do
    render(
      partial: "commands/use/success",
      locals:  {
        name:             name,
        health_restored:  health_restored
      }
    )

    rendered
  end

  let(:health_restored) { 5 }
  let(:name)            { generate(:name) }

  it "renders the success message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t("commands.use.success.message", name: name, count: health_restored)
    )
  end
end
