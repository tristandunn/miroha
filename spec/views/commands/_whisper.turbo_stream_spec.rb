# frozen_string_literal: true

require "rails_helper"

describe "commands/_whisper.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/whisper",
      formats: :turbo_stream,
      locals:  {
        character:   character,
        message:     message,
        target:      target,
        target_name: target&.name
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }

  context "without a target" do
    let(:target) { nil }

    before do
      stub_template("commands/whisper/_unknown.html.erb" => "UNKNOWN_TEMPLATE")
    end

    it "renders the unknown HTML template" do
      expect(html).to include("UNKNOWN_TEMPLATE")
    end
  end

  context "without a target matching the character" do
    let(:target) { character }

    before do
      stub_template("commands/whisper/_self.html.erb" => "SELF_TEMPLATE")
    end

    it "renders the self HTML template" do
      expect(html).to include("SELF_TEMPLATE")
    end
  end

  context "with a target" do
    let(:target) { build_stubbed(:character) }

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
end
