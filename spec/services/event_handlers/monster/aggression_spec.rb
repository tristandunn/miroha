# frozen_string_literal: true

require "rails_helper"

describe EventHandlers::Monster::Aggression, type: :service do
  describe ".on_enter" do
    subject(:on_enter) do
      described_class.on_enter(character: character, monster: monster)
    end

    let(:character)  { build_stubbed(:character) }
    let(:damage)     { 1 }
    let(:monster)    { build_stubbed(:monster) }
    let(:sorted_set) { instance_double(Cache::SortedSet, increment: nil) }

    before do
      allow(Cache::SortedSet).to receive(:new).and_return(sorted_set)
    end

    it "creates a sorted set cache" do
      on_enter

      expect(Cache::SortedSet).to have_received(:new)
        .with(EventHandlers::Monster::Hate::KEY % monster.id, expires_in: EventHandlers::Monster::Hate::TTL)
    end

    it "increments the hate for the character" do
      allow(sorted_set).to receive(:increment)

      on_enter

      expect(sorted_set).to have_received(:increment).with(character.id, damage)
    end
  end
end
