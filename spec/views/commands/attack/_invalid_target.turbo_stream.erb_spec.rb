# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_invalid_target.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/invalid_target",
      formats: :turbo_stream,
      locals:  { target_name: double }
    )

    rendered
  end

  before do
    stub_template("commands/attack/_invalid_target.html.erb" => "INVALID_TARGET_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("INVALID_TARGET_TEMPLATE")
  end
end
