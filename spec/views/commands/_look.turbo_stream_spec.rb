# frozen_string_literal: true

require "rails_helper"

describe "commands/_look.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/look",
      formats: :turbo_stream,
      locals:  {
        description: description
      }
    )

    rendered
  end

  let(:description) { Faker::Lorem.sentence }

  before do
    stub_template("commands/_look.html.erb" => "LOOK_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("LOOK_TEMPLATE")
  end
end
