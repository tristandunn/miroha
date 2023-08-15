# frozen_string_literal: true

require "rails_helper"

describe Commands::Move::EmptyDirection, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:direction) { double }
    let(:instance)  { described_class.new(direction: direction) }

    it { is_expected.to eq(direction: direction) }
  end
end
