# frozen_string_literal: true

require "rails_helper"

describe Commands::Move, type: :service do
  let(:character) { create(:character, room: room) }
  let(:instance)  { described_class.new(command, character: character) }
  let(:room)      { create(:room, x: 0, y: 0, z: 0) }

  describe "constants" do
    it "defines custom throttle limit" do
      expect(described_class::THROTTLE_LIMIT).to eq(1)
    end

    it "defines custom throttle period" do
      expect(described_class::THROTTLE_PERIOD).to eq(1)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    context "with a valid direction" do
      let(:command) { "/move north" }
      let(:result)  { instance_double(described_class::Success) }

      before do
        room_target = create(:room, x: 0, y: 1, z: 0)

        allow(described_class::Success).to receive(:new)
          .with(
            character:   character,
            direction:   "north",
            room_source: room,
            room_target: room_target
          )
          .and_return(result)
      end

      it "delegates to success handler" do
        allow(result).to receive(:call)

        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with an invalid direction" do
      let(:command) { "/move around" }
      let(:result)  { instance_double(described_class::InvalidDirection) }

      before do
        allow(described_class::InvalidDirection).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to invalid direction handler" do
        allow(result).to receive(:call)

        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with an empty direction" do
      let(:command) { "/move north" }
      let(:result)  { instance_double(described_class::EmptyDirection) }

      before do
        allow(described_class::EmptyDirection).to receive(:new)
          .with(direction: "north")
          .and_return(result)
      end

      it "delegates to invalid direction handler" do
        allow(result).to receive(:call)

        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
