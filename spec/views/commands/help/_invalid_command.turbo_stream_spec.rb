# frozen_string_literal: true

require "rails_helper"

describe "commands/help/_invalid_command.turbo_stream.erb" do
  subject(:html) do
    render partial: "commands/help/invalid_command",
           formats: :turbo_stream,
           locals:  { name: "fake" }

    rendered
  end

  before do
    stub_template("commands/help/_invalid_command.html.erb" => "INVALID_COMMAND_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("INVALID_COMMAND_TEMPLATE")
  end
end
