# frozen_string_literal: true

require "rails_helper"

describe "commands/_unknown.turbo_stream.erb", type: :view do
  subject(:html) do
    render partial: "commands/unknown",
           formats: :turbo_stream,
           locals:  { command: "command-name" }

    rendered
  end

  before do
    stub_template("commands/_unknown.html.erb" => "UNKNOWN_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("UNKNOWN_TEMPLATE")
  end
end
