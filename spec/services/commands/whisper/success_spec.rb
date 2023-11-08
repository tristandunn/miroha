# frozen_string_literal: true

require "rails_helper"

describe Commands::Whisper::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { double }
    let(:message)   { double }
    let(:target)    { double }

    let(:instance) do
      described_class.new(character: character, message: message, target: target)
    end

    before do
      allow(instance).to receive(:broadcast_append_later_to)
    end

    it "broadcasts an append later to the target" do
      call

      expect(instance).to have_received(:broadcast_append_later_to)
        .with(target, target: "messages", locals: { character: character, message: message })
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { double }
    let(:message)   { double }
    let(:target)    { double }

    let(:instance) do
      described_class.new(character: character, message: message, target: target)
    end

    it { is_expected.to eq(character: character, message: message, target: target) }
  end
end
