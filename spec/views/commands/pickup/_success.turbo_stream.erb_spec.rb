# frozen_string_literal: true

require "rails_helper"

describe "commands/pickup/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/pickup/success",
      formats: :turbo_stream,
      locals:  {
        character: build_stubbed(:character),
        item:      build_stubbed(:item)
      }
    )

    rendered
  end

  before do
    stub_template("commands/pickup/_success.html.erb" => "SUCCESS_TEMPLATE")
    stub_template("game/_surroundings.html.erb" => "SURROUNDINGS_TEMPLATE")
    stub_template("game/sidebar/navigation/_content.html.erb" => "NAVIGATION_CONTENT_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "replaces the surroundings element" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "surroundings"
    )
  end

  it "replaces the character inventory element" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "character-inventory"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("SUCCESS_TEMPLATE")
  end

  it "renders the surroundings template" do
    expect(html).to include("SURROUNDINGS_TEMPLATE")
  end

  it "renders the navigation content template" do
    expect(html).to include("NAVIGATION_CONTENT_TEMPLATE")
  end
end
