# frozen_string_literal: true

require "rails_helper"

describe Clock::SignOutInactiveCharacters, type: :service do
  describe ".call" do
    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_to)
    end

    context "with an inactive, playing character" do
      it "marks the character as not playing" do
        character = create(:character, :inactive)

        described_class.call

        expect(character.reload).not_to be_playing
      end

      it "broadcasts exit game message to the character" do
        character = create(:character, :inactive)

        described_class.call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_to).with(
          character,
          target:  "messages",
          partial: "commands/exit_game"
        )
      end
    end

    context "with an active, playing character" do
      it "does not mark the character as not playing" do
        character = create(:character)

        described_class.call

        expect(character.reload).to be_playing
      end

      it "does not broadcast exit game message to the character" do
        create(:character)

        described_class.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_to)
      end
    end

    context "with an inactive, not playing character" do
      it "does not broadcast exit game message to the character" do
        create(:character, :inactive, playing: false)

        described_class.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_to)
      end
    end
  end
end
