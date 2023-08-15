# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_invalid_direction.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/move/invalid_direction",
      formats: :turbo_stream
    )

    rendered
  end

  before do
    stub_template("commands/move/_invalid_direction.html.erb" => "INVALID_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("INVALID_TEMPLATE")
  end
end
