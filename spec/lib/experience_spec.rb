# frozen_string_literal: true

require "rails_helper"

describe Experience do
  describe "#+" do
    subject { described_class.new(current: 0, level: 1) }

    it { is_expected.to delegate_method(:+).to(:current) }
  end

  describe "#current" do
    subject { instance.current }

    let(:current)  { 250 }
    let(:instance) { described_class.new(current: current, level: 1) }

    it { is_expected.to eq(250) }
  end

  describe "#needed" do
    subject { instance.needed }

    let(:instance) { described_class.new(current: 0, level: level) }

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
    let(:instance)   { described_class.new(current: experience, level: 1) }

    before do
      allow(instance).to receive(:needed).and_return(500)
    end

    it { is_expected.to eq(400) }
  end

  describe "#remaining_percentage" do
    subject { instance.remaining_percentage }

    let(:instance) { described_class.new(current: experience, level: level) }

    context "when on the first level" do
      let(:level)      { 1 }
      let(:experience) { 100 }

      it { is_expected.to eq(10.0) }
    end

    context "when on the second level" do
      let(:level)      { 2 }
      let(:experience) { 1_914 }

      it { is_expected.to eq(50.0) }
    end
  end
end
