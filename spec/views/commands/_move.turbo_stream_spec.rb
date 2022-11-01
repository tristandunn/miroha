# frozen_string_literal: true

require "rails_helper"

describe "commands/_move.turbo_stream.erb" do
  let(:room) { build_stubbed(:room) }

  before do
    stub_template("commands/_look.turbo_stream.erb" => "LOOK")
    stub_template("commands/move/_failure.turbo_stream.erb" => "MOVE_FAILURE")
    stub_template("commands/move/_success.turbo_stream.erb" => "MOVE_SUCCESS")
    stub_template("commands/move/_surroundings.turbo_stream.erb" => "SURROUNDINGS")
    stub_template("commands/move/_unknown.turbo_stream.erb" => "MOVE_UNKNOWN")
  end

  context "with a room target" do
    subject(:html) do
      render(
        partial: "commands/move",
        formats: :turbo_stream,
        locals:  {
          room_source: room,
          room_target: room
        }
      )

      rendered
    end

    it "renders the look Turbo stream template" do
      expect(html).to include("LOOK")
    end

    it "renders the move success Turbo stream template" do
      expect(html).to include("MOVE_SUCCESS")
    end

    it "renders the move surroundings Turbo stream template" do
      expect(html).to include("SURROUNDINGS")
    end

    it "does not render the failure Turbo stream template" do
      expect(html).not_to include("MOVE_FAILURE")
    end

    it "does not render the unknown Turbo stream template" do
      expect(html).not_to include("MOVE_UNKNOWN")
    end
  end

  context "with a direction and no room target" do
    subject(:html) do
      render(
        partial: "commands/move",
        formats: :turbo_stream,
        locals:  {
          direction:   :north,
          room_target: nil
        }
      )

      rendered
    end

    it "renders the failure Turbo stream template" do
      expect(html).to include("MOVE_FAILURE")
    end

    it "does not render the look Turbo stream template" do
      expect(html).not_to include("LOOK")
    end

    it "does not render the move success Turbo stream template" do
      expect(html).not_to include("MOVE_SUCCESS")
    end

    it "does not render the unknown Turbo stream template" do
      expect(html).not_to include("MOVE_UNKNOWN")
    end

    it "does not render the move surroundings Turbo stream template" do
      expect(html).not_to include("SURROUNDINGS")
    end
  end

  context "with no direction or room target" do
    subject(:html) do
      render(
        partial: "commands/move",
        formats: :turbo_stream,
        locals:  {
          direction:   nil,
          room_target: nil
        }
      )

      rendered
    end

    it "renders the unknown Turbo stream template" do
      expect(html).to include("MOVE_UNKNOWN")
    end

    it "does not render the look Turbo stream template" do
      expect(html).not_to include("LOOK")
    end

    it "does not render the failure Turbo stream template" do
      expect(html).not_to include("MOVE_FAILURE")
    end

    it "does not render the move success Turbo stream template" do
      expect(html).not_to include("MOVE_SUCCESS")
    end

    it "does not render the move surroundings Turbo stream template" do
      expect(html).not_to include("SURROUNDINGS")
    end
  end
end
