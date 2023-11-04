# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/show/_success.turbo_stream.erb" do
  subject(:html) do
    render partial: "commands/alias/show/success",
           formats: :turbo_stream,
           locals:  { aliases: [] }

    rendered
  end

  before do
    stub_template("commands/alias/list/_success.html.erb" => "ALIAS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("ALIAS_TEMPLATE")
  end
end
