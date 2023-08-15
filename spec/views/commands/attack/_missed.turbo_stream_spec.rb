# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_missed.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/missed",
      formats: :turbo_stream,
      locals:  {
        target_name: double
      }
    )

    rendered
  end

  before do
    stub_template("commands/attack/_missed.html.erb" => "MISSED_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("MISSED_TEMPLATE")
  end
end
