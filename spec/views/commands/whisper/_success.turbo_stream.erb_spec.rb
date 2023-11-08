# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_success.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/whisper/success",
      formats: :turbo_stream,
      locals:  {
        character: character,
        message:   message,
        target:    double
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }

  before do
    stub_template("commands/whisper/_source.html.erb" => "SOURCE_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the whisper HTML template" do
    expect(html).to include("SOURCE_TEMPLATE")
  end
end
