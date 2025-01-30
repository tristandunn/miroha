# frozen_string_literal: true

require "rails_helper"

describe Clock::RegenerateHealthJob do
  describe "#perform", :freeze_time do
    subject(:perform) { described_class.new.perform }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_replace_later_to)
    end

    context "with an active, playing, injured character" do
      it "regenerates the health of the character" do
        character = create(:character, current_health: 1, maximum_health: 2)

        perform

        expect(character.reload.current_health).to eq(2)
      end

      it "replaces sidebar for the character" do
        character = create(:character, current_health: 1, maximum_health: 2)

        perform

        expect(Turbo::StreamsChannel).to have_received(:broadcast_replace_later_to)
          .with(
            character,
            target:  :character,
            partial: "game/sidebar/character",
            locals:  {
              character: character
            }
          )
      end
    end

    context "with an active, playing, uninjured character" do
      it "does not regenerate the health of the character" do
        character = create(:character, current_health: 2, maximum_health: 2)

        perform

        expect(character.reload.current_health).to eq(2)
      end

      it "does not broadcast replace" do
        create(:character, current_health: 2, maximum_health: 2)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end

    context "with an injured character that is not active" do
      it "does not regenerate the health of the character" do
        character = create(:character, :inactive, current_health: 1, maximum_health: 2)

        perform

        expect(character.reload.current_health).to eq(1)
      end

      it "does not broadcast replace" do
        create(:character, :inactive, current_health: 1, maximum_health: 2)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end

    context "with an injured character that is not playing" do
      it "does not regenerate the health of the character" do
        character = create(:character, current_health: 1, maximum_health: 2, playing: false)

        perform

        expect(character.reload.current_health).to eq(1)
      end

      it "does not broadcast replace" do
        create(:character, current_health: 1, maximum_health: 2, playing: false)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end

    context "with an injured monster" do
      it "regenerates the health of the monster" do
        monster = create(:monster, current_health: 1, maximum_health: 2)

        perform

        expect(monster.reload.current_health).to eq(2)
      end

      it "does not broadcast replace" do
        create(:monster, current_health: 1, maximum_health: 2)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end

    context "with an uninjured monster" do
      it "does not regenerate the health of the monster" do
        monster = create(:monster, current_health: 2, maximum_health: 2)

        perform

        expect(monster.reload.current_health).to eq(2)
      end

      it "does not broadcast replace" do
        create(:monster, current_health: 2, maximum_health: 2)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end
  end
end
