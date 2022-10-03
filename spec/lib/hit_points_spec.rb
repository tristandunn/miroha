# frozen_string_literal: true

require "rails_helper"

describe HitPoints do
  let(:current)  { 200 }
  let(:instance) { described_class.new(current: current, maximum: maximum) }
  let(:maximum)  { 500 }

  describe "#current" do
    subject { instance.current }

    it { is_expected.to eq(current) }
  end

  describe "#maximum" do
    subject { instance.maximum }

    it { is_expected.to eq(maximum) }
  end

  describe "#remaining_percentage" do
    subject { instance.remaining_percentage }

    it { is_expected.to eq(40.0) }
  end
end
