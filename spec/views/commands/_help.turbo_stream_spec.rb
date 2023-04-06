# frozen_string_literal: true

require "rails_helper"

describe "commands/_help.turbo_stream.erb" do
  subject(:html) do
    render partial: "commands/help",
           formats: :turbo_stream,
           locals:  { commands: [] }

    rendered
  end

  before do
    stub_template("commands/_help.html.erb" => "HELP_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("HELP_TEMPLATE")
  end
end
