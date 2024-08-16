# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Add, type: :service do
  describe ".match?" do
    subject { described_class.match?(arguments) }

    context "with no arguments" do
      let(:arguments) { [] }

      it { is_expected.to be(false) }
    end

    context "with add argument" do
      let(:arguments) { [t("commands.lookup.alias.arguments.add")] }

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
    let(:instance)  { described_class.new("/alias add #{shortcut} #{command}", character: character) }

    context "with a valid shortcut and command" do
      let(:command)  { "/emote" }
      let(:result)   { instance_double(described_class::Success) }
      let(:shortcut) { "/e" }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, command: command, shortcut: shortcut)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with a valid shortcut and command, without slashes" do
      let(:command)  { "emote" }
      let(:result)   { instance_double(described_class::Success) }
      let(:shortcut) { "e" }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, command: "/#{command}", shortcut: shortcut)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with an invalid command" do
      let(:command)  { "/fake" }
      let(:result)   { instance_double(described_class::InvalidCommand) }
      let(:shortcut) { "/f" }

      before do
        allow(described_class::InvalidCommand).to receive(:new)
          .with(command: command)
          .and_return(result)
      end

      it "delegates to invalid command handler" do
        allow(result).to receive(:call)

        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
