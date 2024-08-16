# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Add::InvalidCommand, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:command)  { double }
    let(:instance) { described_class.new(command: command) }

    it { is_expected.to eq(command: command) }
  end
end
