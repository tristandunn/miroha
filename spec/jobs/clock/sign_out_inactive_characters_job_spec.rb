# frozen_string_literal: true

require "rails_helper"

describe Clock::SignOutInactiveCharactersJob do
  describe "#perform" do
    subject(:perform) { described_class.new.perform }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_action_to)
    end

    context "with an inactive, playing character" do
      it "marks the character as not playing" do
        character = create(:character, :inactive)

        perform

        expect(character.reload).not_to be_playing
      end

      it "broadcasts exit game action to the character" do
        character = create(:character, :inactive)

        perform

        expect(Turbo::StreamsChannel).to have_received(:broadcast_action_to).with(
          character,
          action: "exit"
        )
      end
    end

    context "with an active, playing character" do
      it "does not mark the character as not playing" do
        character = create(:character)

        perform

        expect(character.reload).to be_playing
      end

      it "does not broadcast exit game action to the character" do
        create(:character)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_action_to)
      end
    end

    context "with an inactive, not playing character" do
      it "does not broadcast exit game action to the character" do
        create(:character, :inactive, playing: false)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_action_to)
      end
    end
  end
end
