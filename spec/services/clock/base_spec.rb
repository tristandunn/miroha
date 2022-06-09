# frozen_string_literal: true

require "rails_helper"

describe Clock::Base, type: :service do
  describe "#interval" do
    subject { described_class.new.interval }

    let(:interval) { 1.hour }

    before do
      allow(described_class).to receive(:const_get).with(:INTERVAL).and_return(interval)
    end

    it { is_expected.to eq(3_600) }
  end

  describe "#name" do
    subject { described_class.new.name }

    let(:name) { "Test name." }

    before do
      allow(described_class).to receive(:const_get).with(:NAME).and_return(name)
    end

    it { is_expected.to eq(name) }
  end
end
