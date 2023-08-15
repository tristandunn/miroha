# frozen_string_literal: true

require "rails_helper"

describe Commands::Direct::MissingTarget, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:instance)    { described_class.new(target_name: target_name) }
    let(:target_name) { double }

    it { is_expected.to eq(target_name: target_name) }
  end
end
