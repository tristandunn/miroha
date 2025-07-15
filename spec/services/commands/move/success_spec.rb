# frozen_string_literal: true

require "rails_helper"

describe Commands::Move::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character)   { create(:character) }
    let(:direction)   { "north" }
    let(:room_source) { create(:room) }
    let(:room_target) { create(:room) }

    let(:instance) do
      described_class.new(
        character:   character,
        direction:   direction,
        room_source: room_source,
        room_target: room_target
      )
    end

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
    end

    it "moves the character to the target room" do
      call

      expect(character.reload.room).to eq(room_target)
    end

    it "broadcasts the exit template to the source room" do
      call

      expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
        .with(
          room_source,
          partial: "commands/move/exit",
          locals:  {
            character: character,
            direction: direction
          }
        )
    end

    it "broadcasts the enter template to the target room" do
      call

      expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
        .with(
          room_target,
          partial: "commands/move/enter",
          locals:  {
            character: character,
            direction: direction
          }
        )
    end

    it "notifies monsters in the target room of the character entering" do
      monster = create(:monster, :aggressive, room: room_target)

      allow(EventHandlers::Monster::Aggression).to receive(:on_enter)

      call

      expect(EventHandlers::Monster::Aggression).to have_received(:on_enter)
        .with(character: character, monster: monster)
    end
  end

  describe "#locals" do
    subject(:locals) { instance.locals }

    let(:character)   { double }
    let(:direction)   { double }
    let(:room_source) { double }
    let(:room_target) { double }

    let(:instance) do
      described_class.new(
        character:   character,
        direction:   direction,
        room_source: room_source,
        room_target: room_target
      )
    end

    it { is_expected.to eq(room_source: room_source, room_target: room_target) }
  end
end
