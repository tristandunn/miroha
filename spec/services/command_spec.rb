# frozen_string_literal: true

require "rails_helper"

describe Command, type: :service do
  describe ".call" do
    let(:character) { build_stubbed(:character) }
    let(:command)   { double }
    let(:instance)  { double }
    let(:input)     { double }

    before do
      allow(described_class::Parser).to receive(:call).and_return(command)
      allow(command).to receive(:new).and_return(instance)
      allow(instance).to receive(:call)
    end

    it "parses the command" do
      described_class.call(input, character: character)

      expect(described_class::Parser).to have_received(:call).with(input)
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
end
