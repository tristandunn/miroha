# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_hit.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/hit",
      formats: :turbo_stream,
      locals:  {
        damage:      double,
        target_name: double
      }
    )

    rendered
  end

  before do
    stub_template("commands/attack/_hit.html.erb" => "HIT_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("HIT_TEMPLATE")
  end
end
