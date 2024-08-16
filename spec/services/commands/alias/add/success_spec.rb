# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Add::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:account)   { character.account }
    let(:character) { create(:character) }
    let(:command)   { "/emote" }
    let(:instance)  { described_class.new(character: character, command: command, shortcut: shortcut) }
    let(:shortcut)  { "/e" }

    it "adds the alias to the character's account" do
      call

      expect(account.aliases).to have_key(shortcut)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { build_stubbed(:character) }
    let(:command)   { double }
    let(:instance)  { described_class.new(character: character, command: command, shortcut: shortcut) }
    let(:shortcut)  { double }

    it { is_expected.to eq(account: character.account, command: command, shortcut: shortcut) }
  end
end
