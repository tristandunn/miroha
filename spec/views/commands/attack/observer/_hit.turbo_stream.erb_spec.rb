# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/observer/_hit.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/observer/hit",
      formats: :turbo_stream,
      locals:  {
        character:   character,
        target_name: target_name
      }
    )

    rendered
  end

  let(:character)   { build_stubbed(:character) }
  let(:target_name) { generate(:name) }

  before do
    stub_template("commands/attack/observer/_hit.html.erb" => "HIT_TEMPLATE")
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
