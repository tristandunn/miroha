# frozen_string_literal: true

require "rails_helper"

describe Commands::Use::NotConsumable, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { create(:character) }
    let(:instance)  { described_class.new(item: item) }
    let(:item)      { create(:item, owner: character) }

    it { is_expected.to eq(item: item) }
  end
end
