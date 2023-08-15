# frozen_string_literal: true

require "rails_helper"

describe Commands::Base, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("", character: character) }

  describe "class" do
    it { expect(instance).to delegate_method(:call).to(:handler) }
    it { expect(instance).to delegate_method(:locals).to(:handler) }
    it { expect(instance).to delegate_method(:render_options).to(:handler) }
    it { expect(instance).to delegate_method(:rendered?).to(:handler) }
  end

  describe "constants" do
    it "defines default throttle limit" do
      expect(described_class::THROTTLE_LIMIT).to eq(10)
    end

    it "defines default throttle period" do
      expect(described_class::THROTTLE_PERIOD).to eq(5)
    end
  end

  describe ".argument" do
    let(:arguments) { described_class.instance_variable_get(:@arguments) }

    after do
      described_class.instance_variable_set(:@arguments, nil)
    end

    context "with no existing arguments" do
      it "adds the argument" do
        described_class.argument(message: (0..1))

        expect(arguments).to eq(
          {
            described_class.to_s => {
              message: (0..1)
            }
          }
        )
      end
    end

    context "with existing argument" do
      it "combines the arguments" do
        described_class.argument(alias: 0)
        described_class.argument(command: (1..))

        expect(arguments).to eq(
          {
            described_class.to_s => {
              alias:   0,
              command: (1..)
            }
          }
        )
      end
    end
  end

  describe ".arguments" do
    subject { described_class.arguments }

    let(:arguments) { described_class.instance_variable_get(:@arguments) }
    let(:values)    { { alias: 0, command: (1..) } }

    before do
      described_class.argument(**values)
    end

    after do
      described_class.instance_variable_set(:@arguments, nil)
    end

    it { is_expected.to eq(values) }
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
end
