# frozen_string_literal: true

require "rails_helper"

describe "commands/direct/_missing_target.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/direct/missing_target",
      formats: :turbo_stream,
      locals:  {
        target_name: target_name
      }
    )

    rendered
  end

  let(:target_name) { generate(:name) }

  before do
    stub_template("commands/direct/_missing_target.html.erb" => "MISSING_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("MISSING_TEMPLATE")
  end
end
