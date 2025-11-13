# frozen_string_literal: true

require "rails_helper"

describe Commands::Use::InvalidItem, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:instance) { described_class.new(name: name) }
    let(:name)     { generate(:name) }

    it { is_expected.to eq(name: name) }
  end
end
