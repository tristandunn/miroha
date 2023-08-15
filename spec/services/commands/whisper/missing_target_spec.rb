# frozen_string_literal: true

require "rails_helper"

describe Commands::Whisper::MissingTarget, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:instance) { described_class.new(target: target) }
    let(:target)   { double }

    it { is_expected.to eq(target: target) }
  end
end
