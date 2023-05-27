# frozen_string_literal: true

require "rails_helper"

describe Command, type: :service do
  describe ".call" do
    let(:character) { build_stubbed(:character) }
    let(:command)   { Commands::Say }
    let(:instance)  { instance_double(command, call: true) }
    let(:input)     { "/say Hello!" }

    before do
      allow(described_class).to receive(:parse).and_return(command)
      allow(command).to receive(:new).and_return(instance)
    end

    it "parses the command" do
      described_class.call(input, character: character)

      expect(described_class).to have_received(:parse).with(input)
    end

    it "creates an instance of the command" do
      described_class.call(input, character: character)

      expect(command).to have_received(:new).with(input, character: character)
    end

    it "calls the command" do
      described_class.call(input, character: character)

      expect(instance).to have_received(:call).with(no_args)
    end

    it "returns the command" do
      result = described_class.call(input, character: character)

      expect(result).to eq(instance)
    end
  end

  describe ".parse" do
    subject { described_class.parse(input) }

    context "with a known command" do
      let(:input) { "/attack Rat" }

      it { is_expected.to eq(Commands::Attack) }
    end

    context "with an unknown command" do
      let(:input) { "/notareal command" }

      it { is_expected.to eq(Commands::Unknown) }
    end

    context "with no command" do
      let(:input) { "Hello, world!" }

      it { is_expected.to eq(Commands::Say) }
    end
  end
end
