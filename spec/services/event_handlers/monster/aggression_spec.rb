# frozen_string_literal: true

require "rails_helper"

describe EventHandlers::Monster::Aggression, type: :service do
  it { is_expected.to be_a(EventHandlers::Monster::Hate) }

  describe ".on_enter" do
    subject(:on_enter) do
      described_class.on_enter(character: character, monster: monster)
    end

    let(:character) { create(:character) }
    let(:hates)     { Redis::SortedSet.new(described_class::KEY % monster.id) }
    let(:monster)   { create(:monster) }

    context "with no existing hate" do
      it "creates hate against the character for the monster" do
        on_enter

        expect(hates.members(with_scores: true)).to contain_exactly(
          [character.id.to_s, 1]
        )
      end

      it "assigns a TTL for the key" do
        on_enter

        expect(hates.ttl).to be_within(1).of(described_class::TTL)
      end
    end

    context "with existing hate" do
      before do
        hates.incr(character.id, 1)
        hates.expire(1.minute)
      end

      it "does not increment the hate against the character for the monster" do
        on_enter

        expect(hates.members(with_scores: true)).to contain_exactly(
          [character.id.to_s, 1]
        )
      end

      it "refreshes the TTL for the key" do
        on_enter

        expect(hates.ttl).to be_within(1).of(described_class::TTL)
      end
    end
  end
end
