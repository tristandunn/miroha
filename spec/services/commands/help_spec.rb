# frozen_string_literal: true

require "rails_helper"

describe Commands::Help, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("/help #{command}", character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    context "with no command" do
      let(:command) { "" }
      let(:result)  { instance_double(described_class::List) }

      before do
        allow(result).to receive(:call)
        allow(described_class::List).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to list handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with a command" do
      let(:command) { "alias" }
      let(:result)  { instance_double(described_class::Command) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Command).to receive(:new)
          .with(name: command)
          .and_return(result)
      end

      it "delegates to list handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with an invalid command" do
      let(:command) { "/fake" }
      let(:result)  { instance_double(described_class::InvalidCommand) }

      before do
        allow(result).to receive(:call)
        allow(described_class::InvalidCommand).to receive(:new)
          .with(name: "fake")
          .and_return(result)
      end

      it "delegates to list handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
