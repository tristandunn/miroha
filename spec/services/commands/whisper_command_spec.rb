# frozen_string_literal: true

require "rails_helper"

describe Commands::WhisperCommand, type: :service do
  let(:character)   { create(:character) }
  let(:instance)    { described_class.new("/whisper #{target_name} #{message}", character: character) }
  let(:message)     { "Hello." }
  let(:target)      { create(:character, room: character.room) }
  let(:target_name) { target.name.upcase }

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    context "with a valid target" do
      it "broadcasts whisper partial to the target" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            target,
            target:  "messages",
            partial: "commands/whisper",
            locals:  {
              character:   character,
              message:     message,
              target:      target,
              target_name: target_name
            }
          )
      end
    end

    context "with target in a different room" do
      let(:target) { create(:character) }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with character as target" do
      let(:target) { character }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with inactive character as target" do
      let(:target) { create(:character, :inactive, room: character.room) }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with invalid target" do
      let(:target_name) { "Nobody" }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with blank message" do
      let(:message) { " " }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    context "with a valid target" do
      it { is_expected.to eq(true) }
    end

    context "with character as target" do
      let(:target) { character }

      it { is_expected.to eq(true) }
    end

    context "with invalid target" do
      let(:target_name) { "Nobody" }

      it { is_expected.to eq(true) }
    end

    context "with blank message" do
      let(:message) { " " }

      it { is_expected.to eq(true) }
    end
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    it "returns the partial with character and message locals" do
      expect(render_options).to eq(
        partial: "commands/whisper",
        locals:  {
          character:   character,
          message:     message,
          target:      target,
          target_name: target_name
        }
      )
    end
  end
end
