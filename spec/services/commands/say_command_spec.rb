# frozen_string_literal: true

require "rails_helper"

describe Commands::SayCommand, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:command)   { "/say #{message}" }
  let(:instance)  { described_class.new(command, character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    context "with a message" do
      let(:message) { "Hello, world!" }

      it "broadcasts say partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            character.room,
            target:  "messages",
            partial: "commands/say",
            locals:  {
              character: character,
              message:   message
            }
          )
      end
    end

    context "with blank message" do
      let(:message) { " " }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with no message" do
      let(:command) { "/say" }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    let(:message) { "Hello, world!" }

    it { is_expected.to eq(false) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    let(:message) { "Hello, world!" }

    it "returns the partial with character and message locals" do
      expect(render_options).to eq(
        partial: "commands/say",
        locals:  {
          character: character,
          message:   message
        }
      )
    end
  end
end
