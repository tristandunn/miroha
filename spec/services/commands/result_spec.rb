# frozen_string_literal: true

require "rails_helper"

describe Commands::Result, type: :service do
  let(:instance) { test_result_class.new }

  let(:test_result_class) do
    Class.new(described_class) do
      def one
        1
      end

      def two
        2
      end
    end
  end

  describe ".locals" do
    let(:names) { %i(one two) }

    before do
      allow(test_result_class).to receive(:attr_reader)
    end

    it "creates attribute readers" do
      test_result_class.locals(*names)

      expect(test_result_class).to have_received(:attr_reader).with(*names)
    end

    it "defines a method to return the locals" do
      test_result_class.locals(*names)

      expect(instance.locals).to eq(one: 1, two: 2)
    end
  end

  describe "#call" do
    subject { instance.call }

    it { is_expected.to be_nil }
  end

  describe "#render_options" do
    subject { instance.render_options }

    before do
      stub_const(described_class.to_s, test_result_class)
    end

    context "with locals" do
      before do
        test_result_class.locals(:one)

        instance.instance_variable_set(:@one, 1)
      end

      it { is_expected.to eq(partial: "commands/result", locals: { one: 1 }) }
    end

    context "without locals" do
      it { is_expected.to eq(partial: "commands/result", locals: nil) }
    end
  end

  describe "#rendered?" do
    subject { instance.rendered? }

    it { is_expected.to be(true) }
  end
end
