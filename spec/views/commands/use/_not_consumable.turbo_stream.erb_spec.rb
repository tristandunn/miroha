# frozen_string_literal: true

require "rails_helper"

describe "commands/use/_not_consumable.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/use/not_consumable",
      formats: :turbo_stream,
      locals:  {
        item: build_stubbed(:item)
      }
    )

    rendered
  end

  before do
    stub_template("commands/use/_not_consumable.html.erb" => "NOT_CONSUMABLE_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("NOT_CONSUMABLE_TEMPLATE")
  end
end
