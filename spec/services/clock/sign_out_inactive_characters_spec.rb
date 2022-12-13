# frozen_string_literal: true

require "rails_helper"

describe Clock::SignOutInactiveCharacters, type: :service do
  describe "#call" do
    subject(:call) { described_class.new.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_action_to)
    end

    context "with an inactive, playing character" do
      it "marks the character as not playing" do
        character = create(:character, :inactive)

        call

        expect(character.reload).not_to be_playing
      end

      it "broadcasts exit game action to the character" do
        character = create(:character, :inactive)

        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_action_to).with(
          character,
          action: "exit"
        )
      end
    end

    context "with an active, playing character" do
      it "does not mark the character as not playing" do
        character = create(:character)

        call

        expect(character.reload).to be_playing
      end

      it "does not broadcast exit game action to the character" do
        create(:character)

        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_action_to)
      end
    end

    context "with an inactive, not playing character" do
      it "does not broadcast exit game action to the character" do
        create(:character, :inactive, playing: false)

        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_action_to)
      end
    end
  end
end
