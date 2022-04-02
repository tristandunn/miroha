# frozen_string_literal: true

require "rails_helper"

describe Commands::MoveCommand, type: :service do
  let(:character) { create(:character, room: room) }
  let(:instance)  { described_class.new("/move #{direction}", character: character) }
  let(:room)      { create(:room, origin) }
  let(:origin)    { { x: 0, y: 0, z: 0 } }

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

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
    end

    described_class::OFFSETS.each do |offset_direction, offset|
      context "with a room #{offset_direction}" do
        let(:direction) { offset_direction }

        it "moves the character to the target room" do
          room_target = create(:room, origin.merge(offset))

          call

          expect(character.reload.room).to eq(room_target)
        end

        it "broadcasts the enter template to the target room" do
          room_target = create(:room, origin.merge(offset))

          call

          expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
            .with(
              room_target,
              partial: "commands/move/enter",
              locals:  {
                character: character,
                direction: direction,
                room:      room_target
              }
            )
        end

        it "broadcasts the exit template to the source room" do
          create(:room, origin.merge(offset))

          call

          expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
            .with(
              room,
              partial: "commands/move/exit",
              locals:  {
                character: character,
                direction: direction,
                room:      room
              }
            )
        end
      end

      context "with no room #{offset_direction}" do
        let(:direction) { offset_direction }

        it "does not move the character" do
          call

          expect(character.reload.room).to eq(room)
        end

        it "does not broadcast to either room" do
          call

          expect(Turbo::StreamsChannel).not_to have_received(:broadcast_render_later_to)
        end
      end
    end

    context "with invalid direction" do
      let(:direction) { "around" }

      it "does not move the character" do
        call

        expect(character.reload.room).to eq(room)
      end

      it "does not broadcast to either room" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_render_later_to)
      end
    end
  end

  describe "#rendered?" do
    subject { instance.rendered? }

    let(:direction) { "north" }

    it { is_expected.to be(true) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    described_class::OFFSETS.each do |offset_direction, offset|
      context "with a room #{offset_direction}" do
        let(:direction) { offset_direction }

        it "returns the partial with direction, source room, and target room" do
          room_target = create(:room, origin.merge(offset))

          expect(render_options).to eq(
            partial: "commands/move",
            locals:  {
              direction:   direction,
              room_source: room,
              room_target: room_target
            }
          )
        end
      end

      context "with no room #{offset_direction}" do
        let(:direction) { offset_direction }

        it "returns the partial with direction and source room, but no target" do
          expect(render_options).to eq(
            partial: "commands/move",
            locals:  {
              direction:   direction,
              room_source: room,
              room_target: nil
            }
          )
        end
      end
    end

    context "with invalid direction" do
      let(:direction) { "around" }

      it "returns the partial with source room, but no direction or target" do
        expect(render_options).to eq(
          partial: "commands/move",
          locals:  {
            direction:   nil,
            room_source: room,
            room_target: nil
          }
        )
      end
    end
  end
end
