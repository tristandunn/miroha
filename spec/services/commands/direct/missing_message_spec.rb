# frozen_string_literal: true

require "rails_helper"

describe Commands::Direct::MissingMessage, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#rendered?" do
    subject { instance.rendered? }

    let(:instance) { described_class.new }

    it { is_expected.to be(false) }
  end
end
