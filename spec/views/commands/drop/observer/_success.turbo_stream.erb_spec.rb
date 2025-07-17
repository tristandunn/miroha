# frozen_string_literal: true

require "rails_helper"

describe "commands/drop/observer/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/drop/observer/success",
      formats: :turbo_stream,
      locals:  {
        character: build_stubbed(:character),
        item:      build_stubbed(:item)
      }
    )

    rendered
  end

  before do
    stub_template("commands/drop/observer/_success.html.erb" => "OBSERVER_SUCCESS_TEMPLATE")
    stub_template("game/_surroundings.html.erb" => "SURROUNDINGS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "replaces the surroundings" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "surroundings"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("OBSERVER_SUCCESS_TEMPLATE")
  end

  it "renders the surroundings template" do
    expect(html).to include("SURROUNDINGS_TEMPLATE")
  end
end
