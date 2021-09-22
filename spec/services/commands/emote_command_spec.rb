# frozen_string_literal: true

require "rails_helper"

describe Commands::EmoteCommand, type: :service do
  let(:character)           { build_stubbed(:character) }
  let(:default_punctuation) { described_class::DEFAULT_PUNCTUATION }

  describe "#call" do
    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    it "broadcasts emote partial to the room" do
      instance = described_class.new("/emote laughs", character: character)

      instance.call

      expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
        .with(
          character.room,
          target:  "messages",
          partial: "commands/emote",
          locals:  {
            message: "#{character.name} laughs#{default_punctuation}"
          }
        )
    end

    context "with included punctuation" do
      it "does not append default punctuation" do
        described_class::PUNCTUATION_CHARACTERS.each do |punctuation|
          message  = "laughs#{punctuation}"
          instance = described_class.new("/emote #{message}", character: character)

          instance.call

          expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
            .with(
              character.room,
              target:  "messages",
              partial: "commands/emote",
              locals:  {
                message: "#{character.name} #{message}"
              }
            )
        end
      end
    end

    context "with blank argument" do
      it "does not broadcast" do
        instance = described_class.new("/emote ", character: character)

        instance.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with no argument" do
      it "does not broadcast" do
        instance = described_class.new("/emote", character: character)

        instance.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end

  describe "#render?" do
    it "returns false" do
      instance = described_class.new("/emote laughs", character: character)

      expect(instance).not_to be_rendered
    end
  end

  describe "#render_options" do
    it "returns the partial with character and message locals" do
      instance = described_class.new("/emote laughs", character: character)

      result = instance.render_options

      expect(result).to eq(
        partial: "commands/emote",
        locals:  {
          message: "#{character.name} laughs#{default_punctuation}"
        }
      )
    end
  end
end
