# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Remove, type: :service do
  describe ".match?" do
    subject { described_class.match?(arguments) }

    context "with no arguments" do
      let(:arguments) { [] }

      it { is_expected.to be(false) }
    end

    context "with remove argument" do
      let(:arguments) { [t("commands.lookup.alias.arguments.remove")] }

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
    let(:instance)  { described_class.new("/alias remove #{name}", character: character) }

    context "with a valid alias" do
      let(:name)   { "/a" }
      let(:result) { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, name: name)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with an invalid alias" do
      let(:name) { "/fake" }
      let(:result) { instance_double(described_class::UnknownAlias) }

      before do
        allow(described_class::UnknownAlias).to receive(:new)
          .with(name: name)
          .and_return(result)
      end

      it "delegates to unknow alias handler" do
        allow(result).to receive(:call)

        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
