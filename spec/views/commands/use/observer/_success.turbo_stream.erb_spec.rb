# frozen_string_literal: true

require "rails_helper"

describe "commands/use/observer/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/use/observer/success",
      formats: :turbo_stream,
      locals:  {
        character: build_stubbed(:character),
        name:      generate(:name)
      }
    )

    rendered
  end

  before do
    stub_template("commands/use/observer/_success.html.erb" => "OBSERVER_SUCCESS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("OBSERVER_SUCCESS_TEMPLATE")
  end
end
