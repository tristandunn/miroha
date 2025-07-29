# frozen_string_literal: true

require "rails_helper"

describe EventHandlers::Monster::Hate, type: :service do
  describe ".on_character_attacked" do
    subject(:on_character_attacked) do
      described_class.on_character_attacked(character: character, damage: damage, monster: monster)
    end

    let(:character)  { build_stubbed(:character) }
    let(:damage)     { SecureRandom.random_number(1..100) }
    let(:monster)    { build_stubbed(:monster) }
    let(:sorted_set) { instance_double(Cache::SortedSet, increment: nil) }

    before do
      allow(Cache::SortedSet).to receive(:new).and_return(sorted_set)
    end

    it "creates a sorted set cache" do
      on_character_attacked

      expect(Cache::SortedSet).to have_received(:new)
        .with(described_class::KEY % monster.id, expires_in: described_class::TTL)
    end

    it "increments the hate for the character" do
      allow(sorted_set).to receive(:increment)

      on_character_attacked

      expect(sorted_set).to have_received(:increment).with(character.id, damage)
    end
  end
end
