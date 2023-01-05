# frozen_string_literal: true

require "rails_helper"

describe Clock::MonstersAttackCharacters, type: :service do
  describe "constants" do
    it "defines an interval" do
      expect(described_class::INTERVAL).to eq(5.seconds)
    end

    it "defines a limit" do
      expect(described_class::LIMIT).to eq(128)
    end

    it "defines a name" do
      expect(described_class::NAME).to eq("Monsters attack characters.")
    end
  end

  describe "#call", :freeze_time do
    subject(:call) { described_class.new.call }

    let(:monster) { create(:monster) }

    before do
      allow(Monsters::Attack).to receive(:call)
    end

    context "with an active, playing character" do
      it "calls monsters in the room to attack" do
        create(:monster)
        create(:character, room: monster.room)

        call

        expect(Monsters::Attack).to have_received(:call).with(monster).once
      end

      it "limits the number of attacking monsters" do
        relation = instance_double(ActiveRecord::Relation)
        allow(Monster).to receive(:where).with({ room_id: [] }).and_return(relation)
        allow(relation).to receive(:limit).with(described_class::LIMIT).and_return([])

        call

        expect(relation).to have_received(:limit).with(described_class::LIMIT)
      end
    end

    context "with a character that is not active" do
      it "does not attack" do
        create(:character, room: monster.room, active_at: 1.hour.ago)

        call

        expect(Monsters::Attack).not_to have_received(:call)
      end
    end

    context "with a character that is not playing" do
      it "does not attack" do
        create(:character, room: monster.room, playing: false)

        call

        expect(Monsters::Attack).not_to have_received(:call)
      end
    end
  end
end
