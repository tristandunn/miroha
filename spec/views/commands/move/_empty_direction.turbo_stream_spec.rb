# frozen_string_literal: true

require "rails_helper"

describe "commands/move/_empty_direction.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/move/empty_direction",
      formats: :turbo_stream,
      locals:  {
        direction: :north
      }
    )

    rendered
  end

  before do
    stub_template("commands/move/_empty_direction.html.erb" => "EMPTY_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("EMPTY_TEMPLATE")
  end
end
