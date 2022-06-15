# frozen_string_literal: true

require "rails_helper"

describe "commands/_attack.turbo_stream.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/attack",
      formats: :turbo_stream,
      locals:  {
        damage:      damage,
        target:      target,
        target_name: target_name
      }
    )

    rendered
  end

  let(:damage)      { rand(1..10) }
  let(:target_name) { generate(:name) }

  context "with a living target" do
    let(:target) { build_stubbed(:monster) }

    before do
      stub_template("commands/attack/attacker/_hit.html.erb" => "HIT_TEMPLATE")
    end

    it "renders the hit HTML template" do
      expect(html).to include("HIT_TEMPLATE")
    end
  end

  context "with a missed target" do
    let(:damage) { 0 }
    let(:target) { build_stubbed(:monster) }

    before do
      stub_template("commands/attack/attacker/_missed.html.erb" => "MISSED_TEMPLATE")
    end

    it "renders the missed HTML template" do
      expect(html).to include("MISSED_TEMPLATE")
    end
  end

  context "with a killed target" do
    let(:target) { build_stubbed(:monster, current_health: 0) }

    before do
      stub_template("commands/attack/attacker/_killed.html.erb" => "KILLED_TEMPLATE")
    end

    it "renders the hit HTML template" do
      expect(html).to include("KILLED_TEMPLATE")
    end

    it "removes the target from the surrounding monsters element" do
      expect(html).to have_turbo_stream_element(
        action: "remove",
        target: "surrounding_monster_#{target.id}"
      )
    end
  end

  context "without a target" do
    let(:target) { nil }

    before do
      stub_template("commands/attack/attacker/_unknown.html.erb" => "UNKNOWN_TEMPLATE")
    end

    it "renders the unknown HTML template" do
      expect(html).to include("UNKNOWN_TEMPLATE")
    end
  end
end
