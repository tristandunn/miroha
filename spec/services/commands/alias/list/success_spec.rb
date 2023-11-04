# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::List::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:instance)  { described_class.new(character: character) }
    let(:character) { build_stubbed(:character) }

    it { is_expected.to eq(aliases: character.account.aliases) }
  end
end
