# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_failure.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/move/failure",
      formats: :turbo_stream,
      locals:  {
        direction: :north
      }
    )

    rendered
  end

  before do
    stub_template("commands/move/_failure.html.erb" => "FAILURE_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("FAILURE_TEMPLATE")
  end
end
