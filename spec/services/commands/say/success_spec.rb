# frozen_string_literal: true

require "rails_helper"

describe Commands::Say::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { instance_double(Character, room_gid: room_gid) }
    let(:message)   { double }
    let(:room_gid)  { SecureRandom.hex }

    let(:instance) do
      described_class.new(character: character, message: message)
    end

    before do
      allow(instance).to receive(:broadcast_append_later_to)
    end

    it "broadcasts an append later to the character's room" do
      call

      expect(instance).to have_received(:broadcast_append_later_to)
        .with(room_gid, target: "messages")
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { double }
    let(:message)   { double }

    let(:instance) do
      described_class.new(character: character, message: message)
    end

    it { is_expected.to eq(character: character, message: message) }
  end

  describe "#rendered?" do
    subject { instance.rendered? }

    let(:character) { double }
    let(:message)   { double }

    let(:instance) do
      described_class.new(character: character, message: message)
    end

    it { is_expected.to be(false) }
  end
end
