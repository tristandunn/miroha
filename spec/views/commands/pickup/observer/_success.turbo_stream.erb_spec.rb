# frozen_string_literal: true

require "rails_helper"

describe "commands/pickup/observer/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/pickup/observer/success",
      formats: :turbo_stream,
      locals:  {
        character: build_stubbed(:character),
        item:      item
      }
    )

    rendered
  end

  let(:item) { build_stubbed(:item) }

  before do
    stub_template("commands/pickup/observer/_success.html.erb" => "OBSERVER_SUCCESS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "removes the surroundings item element" do
    expect(html).to have_turbo_stream_element(
      action: "remove",
      target: "surrounding_item_#{item.id}"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("OBSERVER_SUCCESS_TEMPLATE")
  end
end
