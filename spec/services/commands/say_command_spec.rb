# frozen_string_literal: true

require "rails_helper"

describe Commands::SayCommand, type: :service do
  let(:character) { build_stubbed(:character) }

  describe "#call" do
    it "broadcasts say partial to the room" do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
      instance = described_class.new("/say Hello, world!", character: character)

      instance.call

      expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
        .with(
          character.room,
          target:  "messages",
          partial: "commands/say",
          locals:  {
            character: character,
            message:   "Hello, world!"
          }
        )
    end

    context "with blank argument" do
      it "does not broadcast" do
        allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
        instance = described_class.new("/say ", character: character)

        instance.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with no argument" do
      it "does not broadcast" do
        allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
        instance = described_class.new("/say", character: character)

        instance.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end

  describe "#render?" do
    it "returns false" do
      instance = described_class.new("/say Hi", character: character)

      expect(instance).not_to be_rendered
    end
  end

  describe "#render_options" do
    it "returns the partial with character and message locals" do
      instance = described_class.new("/say Hi", character: character)

      result = instance.render_options

      expect(result).to eq(
        partial: "commands/say",
        locals:  {
          character: character,
          message:   "Hi"
        }
      )
    end
  end
end
