# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::List, type: :service do
  describe ".match?" do
    subject { described_class.match?(arguments) }

    context "with no arguments" do
      let(:arguments) { [] }

      it { is_expected.to be(true) }
    end

    context "with list argument" do
      let(:arguments) { ["list"] }

      it { is_expected.to be(true) }
    end

    context "with other arguments" do
      let(:arguments) { %w(fake list) }

      it { is_expected.to be(false) }
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { build_stubbed(:character) }
    let(:instance)  { described_class.new("/alias", character: character) }
    let(:result)    { instance_double(described_class::Success) }

    before do
      allow(result).to receive(:call)
      allow(described_class::Success).to receive(:new)
        .with(character: character)
        .and_return(result)
    end

    it "delegates to success handler" do
      call

      expect(result).to have_received(:call).with(no_args)
    end
  end
end
