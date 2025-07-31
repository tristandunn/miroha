# frozen_string_literal: true

require "rails_helper"

describe StateMachine::Callback do
  describe "#call" do
    subject { described_class.new(callback: -> {}) }

    it { is_expected.to delegate_method(:call).to(:callback) }
  end

  describe "#valid?" do
    subject { instance.valid? }

    let(:instance) { described_class.new(callback: -> {}, from: from, to: to) }

    context "with :from and :to blank" do
      let(:from) { nil }
      let(:to)   { nil }

      it "returns true with a blank :from and :to" do
        expect(instance.valid?(from: nil, to: nil)).to be(true)
      end

      it "returns true with a blank :from and present :to" do
        expect(instance.valid?(from: nil, to: "state")).to be(true)
      end

      it "returns true with a present :from and blank :to" do
        expect(instance.valid?(from: "state", to: nil)).to be(true)
      end

      it "returns true with a present :from and present :to" do
        expect(instance.valid?(from: "state", to: "state")).to be(true)
      end
    end

    context "with :from blank and :to present" do
      let(:from) { nil }
      let(:to)   { [:state] }

      it "returns true with a blank :from and valid :to" do
        expect(instance.valid?(from: nil, to: "state")).to be(true)
      end

      it "returns true with an invalid :from and valid :to" do
        expect(instance.valid?(from: "wrong", to: "state")).to be(true)
      end

      it "returns false with a blank :from and invalid :to" do
        expect(instance.valid?(from: nil, to: "wrong")).to be(false)
      end
    end

    context "with :from present and :to blank" do
      let(:from) { :state }
      let(:to)   { [] }

      it "returns true with a valid :from and blank :to" do
        expect(instance.valid?(from: "state", to: nil)).to be(true)
      end

      it "returns true with a valid :from and an invalid :to" do
        expect(instance.valid?(from: "state", to: "wrong")).to be(true)
      end

      it "returns false with an invalid :from and blank :to" do
        expect(instance.valid?(from: "wrong", to: nil)).to be(false)
      end
    end

    context "with :from present and :to present" do
      let(:from) { :state }
      let(:to)   { :next }

      it "returns true with a valid :from and valid :to" do
        expect(instance.valid?(from: "state", to: "next")).to be(true)
      end

      it "returns true with a blank :from and valid :to" do
        expect(instance.valid?(from: nil, to: "next")).to be(true)
      end

      it "returns false with a valid :from and invalid :to" do
        expect(instance.valid?(from: "state", to: "wrong")).to be(false)
      end

      it "returns false with an invalid :from and valid :to" do
        expect(instance.valid?(from: "wrong", to: :next)).to be(false)
      end
    end
  end
end
