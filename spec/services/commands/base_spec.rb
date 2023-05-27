# frozen_string_literal: true

require "rails_helper"

describe Commands::Base, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("", character: character) }

  describe "constants" do
    it "defines default throttle limit" do
      expect(described_class::THROTTLE_LIMIT).to eq(10)
    end

    it "defines default throttle period" do
      expect(described_class::THROTTLE_PERIOD).to eq(5)
    end
  end

  describe ".limit" do
    subject { described_class.limit }

    let(:value) { rand }

    before do
      allow(described_class).to receive(:const_get).with(:THROTTLE_LIMIT).and_return(value)
    end

    it { is_expected.to eq(value) }
  end

  describe ".period" do
    subject { described_class.period }

    let(:value) { rand }

    before do
      allow(described_class).to receive(:const_get).with(:THROTTLE_PERIOD).and_return(value)
    end

    it { is_expected.to eq(value) }
  end

  describe "#call" do
    subject(:call) { instance.call }

    it { is_expected.to be_nil }
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    it { is_expected.to be(false) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    let(:instance) { subclass.new("", character: nil) }
    let(:subclass) { Class.new(described_class) }

    before do
      stub_const("Commands::Example::Subclass", subclass)
    end

    it "returns the partial with no locals" do
      expect(render_options).to eq(
        partial: "commands/example/subclass",
        locals:  {}
      )
    end
  end
end
