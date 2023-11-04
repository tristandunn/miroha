# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/show/_unknown_alias.turbo_stream.erb" do
  subject(:html) do
    render partial: "commands/alias/show/unknown_alias",
           formats: :turbo_stream,
           locals:  { name: "unknown" }

    rendered
  end

  before do
    stub_template("commands/alias/show/_unknown_alias.html.erb" => "UKNOWN_ALIAS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("UKNOWN_ALIAS_TEMPLATE")
  end
end
