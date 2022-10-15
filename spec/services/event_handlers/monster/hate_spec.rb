# frozen_string_literal: true

require "rails_helper"

describe EventHandlers::Monster::Hate, type: :service do
  describe ".on_attacked" do
    subject(:on_attacked) do
      described_class.on_attacked(character: character, damage: damage, monster: monster)
    end

    let(:character) { create(:character) }
    let(:damage)    { SecureRandom.random_number(1..100) }
    let(:hates)     { Redis::SortedSet.new(described_class::KEY % monster.id) }
    let(:monster)   { create(:monster) }

    context "with no existing hate" do
      it "creates hate against the character for the monster" do
        on_attacked

        expect(hates.members(with_scores: true)).to contain_exactly(
          [character.id.to_s, damage.to_f]
        )
      end

      it "assigns a TTL for the key" do
        on_attacked

        expect(hates.ttl).to be_within(1).of(described_class::TTL)
      end
    end

    context "with existing hate" do
      before do
        hates.incr(character.id, 1)
        hates.expire(1.minute)
      end

      it "updates the hate against the character for the monter" do
        on_attacked

        expect(hates.members(with_scores: true)).to contain_exactly(
          [character.id.to_s, (damage + 1).to_f]
        )
      end

      it "refreshes the TTL for the key" do
        on_attacked

        expect(hates.ttl).to be_within(1).of(described_class::TTL)
      end
    end
  end
end
