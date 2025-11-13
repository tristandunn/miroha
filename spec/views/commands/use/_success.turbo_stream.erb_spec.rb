# frozen_string_literal: true

require "rails_helper"

describe "commands/use/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/use/success",
      formats: :turbo_stream,
      locals:  {
        character:       build_stubbed(:character),
        item:            item,
        adjusted_health: 5
      }
    )

    rendered
  end

  let(:item) { build_stubbed(:item) }

  before do
    stub_template("commands/use/_success.html.erb" => "SUCCESS_TEMPLATE")
    stub_template("game/_sidebar.html.erb" => "SIDEBAR_TEMPLATE")
    stub_template("game/sidebar/_navigation.html.erb" => "NAVIGATION_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "replaces the sidebar" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "sidebar"
    )
  end

  it "replaces the navigation" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "navigation"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("SUCCESS_TEMPLATE")
  end

  it "renders the sidebar template" do
    expect(html).to include("SIDEBAR_TEMPLATE")
  end

  it "renders the navigation template" do
    expect(html).to include("NAVIGATION_TEMPLATE")
  end
end
