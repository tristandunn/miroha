# frozen_string_literal: true

require "rails_helper"

describe "commands/alias/add/_success.turbo_stream.erb" do
  subject(:html) do
    render partial: "commands/alias/add/success",
           formats: :turbo_stream,
           locals:  { account: account, command: "/emote", shortcut: "/e" }

    rendered
  end

  let(:account) { build_stubbed(:account) }

  before do
    stub_template("commands/alias/add/_success.html.erb" => "SUCCESS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("SUCCESS_TEMPLATE")
  end
end
