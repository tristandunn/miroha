# frozen_string_literal: true

require "rails_helper"

describe Commands::Emote, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:command)   { "/emote #{message}" }
  let(:instance)  { described_class.new(command, character: character) }
  let(:message)   { "laughs" }

  describe "#call" do
    subject(:call) { instance.call }

    context "with a message" do
      let(:result) { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, message: message)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with blank message" do
      let(:message) { " " }
      let(:result)  { instance_double(described_class::MissingMessage) }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingMessage).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to missing message handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with no message" do
      let(:message) { nil }
      let(:result)  { instance_double(described_class::MissingMessage) }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingMessage).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to missing message handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
