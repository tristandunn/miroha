# frozen_string_literal: true

require "rails_helper"

describe Experience do
  describe "#needed" do
    subject { instance.needed }

    let(:instance) { described_class.new(experience: 0, level: level) }

    context "when on the first level" do
      let(:level) { 1 }

      it { is_expected.to eq(1_000) }
    end

    context "when on the second level" do
      let(:level) { 2 }

      it { is_expected.to eq(2_828) }
    end
  end

  describe "#remaining" do
    subject { instance.remaining }

    let(:experience) { 100 }
    let(:instance)   { described_class.new(experience: experience, level: 1) }

    before do
      allow(instance).to receive(:needed).and_return(500)
    end

    it { is_expected.to eq(400) }
  end

  describe "#remaining_percentage" do
    subject { instance.remaining_percentage }

    let(:experience) { 100 }
    let(:instance)   { described_class.new(experience: experience, level: 1) }

    before do
      allow(instance).to receive(:needed).and_return(500)
    end

    it { is_expected.to eq(20.0) }
  end
end
