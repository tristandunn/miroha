# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Remove::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:account)   { character.account }
    let(:character) { create(:character) }
    let(:instance)  { described_class.new(character: character, name: name) }
    let(:name)      { "/a" }

    it "removes the alias from the character's account" do
      call

      expect(account.aliases).not_to have_key(name)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { build_stubbed(:character) }
    let(:instance)  { described_class.new(character: character, name: name) }
    let(:name)      { double }

    it { is_expected.to eq(name: name) }
  end
end
