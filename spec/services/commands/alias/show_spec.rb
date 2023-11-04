# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Show, type: :service do
  describe ".match?" do
    subject { described_class.match?(arguments) }

    context "with show argument" do
      let(:arguments) { %w(show u) }

      it { is_expected.to be(true) }
    end

    context "with no arguments" do
      let(:arguments) { [] }

      it { is_expected.to be(false) }
    end

    context "with other arguments" do
      let(:arguments) { %w(fake list) }

      it { is_expected.to be(false) }
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:account)   { build_stubbed(:account, aliases: aliases) }
    let(:aliases)   { { "d" => "/move down", "u" => "/move up" } }
    let(:character) { build_stubbed(:character, account: account) }

    context "with a valid alias" do
      let(:instance) { described_class.new("/alias show u", character: character) }
      let(:result)   { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(aliases: { "u" => "/move up" })
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with an invalid alias" do
      let(:instance) { described_class.new("/alias show x", character: character) }
      let(:result)   { instance_double(described_class::UnknownAlias) }

      before do
        allow(result).to receive(:call)
        allow(described_class::UnknownAlias).to receive(:new)
          .with(name: "x")
          .and_return(result)
      end

      it "delegates to unknown alias handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
