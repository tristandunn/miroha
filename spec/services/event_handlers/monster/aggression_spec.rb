# frozen_string_literal: true

require "rails_helper"

describe EventHandlers::Monster::Aggression, type: :service do
  describe ".on_enter" do
    subject(:on_enter) do
      described_class.on_enter(character: character, monster: monster)
    end

    let(:character) { build_stubbed(:character) }
    let(:damage)    { 1 }
    let(:monster)   { build_stubbed(:monster) }

    it "increments the hate for the character" do
      allow(EventHandlers::Monster::Hate).to receive(:on_attacked)

      on_enter

      expect(EventHandlers::Monster::Hate).to have_received(:on_attacked)
        .with(character: character, monster: monster, damage: damage)
    end
  end
end
