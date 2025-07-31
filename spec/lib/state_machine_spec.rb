# frozen_string_literal: true

require "rails_helper"

describe StateMachine do
  before do
    described_class.instance_variable_set(:@callbacks, nil)
    described_class.instance_variable_set(:@states, nil)
    described_class.instance_variable_set(:@successors, nil)
  end

  describe "#initialize" do
    let(:instance) { described_class.new }

    it "assigns the current state to the first state" do
      described_class.state(:first, :second)

      expect(instance.current_state).to eq("first")
    end
  end

  describe ".after_transition" do
    let(:block)    { -> {} }
    let(:instance) { described_class.new }

    it "adds an after transition callback" do
      described_class.after_transition(&block)

      expect(described_class.callbacks[:after]).to contain_exactly(
        an_object_having_attributes(from: nil, to: [], callback: block)
      )
    end
  end

  describe ".guard_transition" do
    let(:block)    { -> {} }
    let(:instance) { described_class.new }

    it "adds a guard callback" do
      described_class.guard_transition(&block)

      expect(described_class.callbacks[:guard]).to contain_exactly(
        an_object_having_attributes(from: nil, to: [], callback: block)
      )
    end
  end

  describe ".state" do
    let(:states) { described_class.states }

    context "with a single state" do
      before do
        described_class.state(:one)
      end

      it "defines the state" do
        expect(states).to eq(["one"])
      end
    end

    context "with multiple states" do
      before do
        described_class.state(:one, "two", :three)
      end

      it "defines the state" do
        expect(states).to eq(%w(one two three))
      end
    end
  end

  describe ".states" do
    subject { described_class.states }

    it { is_expected.to eq([]) }
  end

  describe ".successors" do
    subject { described_class.successors }

    it { is_expected.to eq({}) }
  end

  describe ".transition" do
    subject(:transition) { described_class.transition(from: from, to: to) }

    let(:successors) { described_class.successors }

    context "with a :from and a single :to present" do
      let(:from) { :from }
      let(:to)   { :to }

      it "assigns a successor" do
        transition

        expect(successors).to eq("from" => ["to"])
      end
    end

    context "with a :from and multiple :to present" do
      let(:from) { :from }
      let(:to)   { [:to, nil, :another] }

      it "assigns successors that are present" do
        transition

        expect(successors).to eq("from" => %w(to another))
      end
    end

    context "with no :to present" do
      let(:from) { :from }
      let(:to)   { nil }

      it "does not assign a successor" do
        transition

        expect(successors).to be_empty
      end
    end

    context "with no :from or :to present" do
      let(:from) { nil }
      let(:to)   { nil }

      it "does not assign a successor" do
        transition

        expect(successors).to be_empty
      end
    end
  end

  describe "#transition_to" do
    subject(:transition_to) { instance.transition_to(state) }

    let(:instance) { described_class.new }

    before do
      described_class.state(:one, :two, :three)
      described_class.transition(from: :one, to: :two)
    end

    context "with a valid transition" do
      let(:state) { :two }

      it { is_expected.to be_truthy }

      it "updates the current state" do
        transition_to

        expect(instance.current_state).to eq("two")
      end

      context "with an after transition callback" do
        it "calls the callback" do
          expect do |block|
            described_class.after_transition(&block)

            transition_to
          end.to yield_control
        end
      end
    end

    context "with a successful guard" do
      let(:state) { :two }

      before do
        described_class.guard_transition { true }
      end

      it { is_expected.to be_truthy }
    end

    context "with no valid transition" do
      before do
        instance.transition_to(:two)
      end

      it "returns false" do
        expect(instance.transition_to(:three)).to be_falsey
      end

      it "does not update the current state" do
        instance.transition_to(:three)

        expect(instance.current_state).to eq("two")
      end

      context "with an after transition callback" do
        it "does not call the callback" do
          expect do |block|
            described_class.after_transition(&block)

            instance.transition_to(:three)
          end.not_to yield_control
        end
      end
    end

    context "with an unsuccessful guard" do
      let(:state) { :two }

      before do
        described_class.guard_transition { false }
      end

      it { is_expected.to be_falsey }
    end

    context "with an invalid transition" do
      let(:state) { :three }

      it { is_expected.to be_falsey }
    end
  end
end
