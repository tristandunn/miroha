# frozen_string_literal: true

require "rails_helper"

describe "commands/look/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/look/success",
      formats: :turbo_stream,
      locals:  {
        description: description
      }
    )

    rendered
  end

  let(:description) { Faker::Lorem.sentence }

  before do
    stub_template("commands/look/_success.html.erb" => "SUCCESS_TEMPLATE")
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
