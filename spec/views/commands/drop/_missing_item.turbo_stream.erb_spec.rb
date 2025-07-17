# frozen_string_literal: true

require "rails_helper"

describe "commands/drop/_missing_item.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/drop/missing_item",
      formats: :turbo_stream
    )

    rendered
  end

  before do
    stub_template("commands/drop/_missing_item.html.erb" => "MISSING_ITEM_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("MISSING_ITEM_TEMPLATE")
  end
end
