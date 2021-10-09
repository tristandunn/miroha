# frozen_string_literal: true

require "rails_helper"

describe "commands/_direct.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/direct",
      formats: :turbo_stream,
      locals:  {
        character:   character,
        target:      target,
        target_name: target&.name
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }

  context "without a target" do
    let(:target) { nil }

    before do
      stub_template("commands/direct/_unknown.html.erb" => "UNKNOWN_TEMPLATE")
    end

    it "renders the unknown HTML template" do
      expect(html).to include("UNKNOWN_TEMPLATE")
    end
  end

  context "without a target matching the character" do
    let(:target) { character }

    before do
      stub_template("commands/direct/_self.html.erb" => "SELF_TEMPLATE")
    end

    it "renders the self HTML template" do
      expect(html).to include("SELF_TEMPLATE")
    end
  end
end
