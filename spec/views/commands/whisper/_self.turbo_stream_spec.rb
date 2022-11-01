# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_self.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/whisper/self",
      formats: :turbo_stream
    )

    rendered
  end

  before do
    stub_template("commands/whisper/_self.html.erb" => "SELF_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("SELF_TEMPLATE")
  end
end
