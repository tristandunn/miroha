# frozen_string_literal: true

require "rails_helper"

describe Commands::Direct, type: :service do
  let(:character) { create(:character) }
  let(:instance)  { described_class.new("/direct #{target.name} #{message}", character: character) }
  let(:message)   { "Hello." }
  let(:target)    { create(:character, room: character.room) }

  describe "#call" do
    subject(:call) { instance.call }

    context "with a valid target" do
      let(:result) { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, message: message, target: target)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with target in a different room" do
      let(:result) { instance_double(described_class::MissingTarget) }
      let(:target) { create(:character) }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingTarget).to receive(:new)
          .with(target_name: target.name)
          .and_return(result)
      end

      it "delegates to missing target handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with character as target" do
      let(:target) { character }
      let(:result) { instance_double(described_class::InvalidTarget) }

      before do
        allow(result).to receive(:call)
        allow(described_class::InvalidTarget).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to invalid target handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with inactive character as target" do
      let(:result) { instance_double(described_class::MissingTarget) }
      let(:target) { create(:character, :inactive, room: character.room) }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingTarget).to receive(:new)
          .with(target_name: target.name)
          .and_return(result)
      end

      it "delegates to missing target handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with invalid target" do
      let(:result) { instance_double(described_class::MissingTarget) }
      let(:target) { instance_double(Character, name: "Nobody") }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingTarget).to receive(:new)
          .with(target_name: target.name)
          .and_return(result)
      end

      it "delegates to missing target handler" do
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
  end
end
