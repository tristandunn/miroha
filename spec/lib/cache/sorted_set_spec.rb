# frozen_string_literal: true

require "rails_helper"

describe Cache::SortedSet, :cache do
  let(:expires_in) { 1.minute }
  let(:key)        { "test-key" }
  let(:instance)   { described_class.new(key, expires_in: expires_in) }

  describe "#increment" do
    subject(:increment) { instance.increment(member, amount) }

    let(:amount) { 2 }
    let(:member) { "member-id" }

    context "with no existing member" do
      it "writes the new member and amount" do
        allow(Rails.cache).to receive(:write)

        increment

        expect(Rails.cache).to have_received(:write)
          .with(key, { member => amount }, expires_in: expires_in)
      end
    end

    context "with an existing member" do
      before do
        Rails.cache.write(key, { member => 10 })
      end

      it "writes the new amount to the member" do
        allow(Rails.cache).to receive(:write)

        increment

        expect(Rails.cache).to have_received(:write)
          .with(key, { member => (10 + amount) }, expires_in: expires_in)
      end
    end
  end

  describe "#top" do
    subject(:top) { instance.top(count) }

    let(:count) { 2 }

    context "with no members" do
      it { is_expected.to eq([]) }
    end

    context "with members" do
      before do
        instance.increment(1, 3)
        instance.increment(2, 10)
        instance.increment(3, 1)
      end

      it { is_expected.to eq([2, 1]) }
    end
  end
end
