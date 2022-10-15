# frozen_string_literal: true

require "rails_helper"

describe EventHandlers, type: :service do
  describe ".all" do
    subject { described_class.all }

    let(:class_stub) { Class.new }

    before do
      stub_const("EventHandlers::TestHandler::TestClass", class_stub)
    end

    after do
      described_class.instance_variable_set(:@all, nil)
    end

    it { is_expected.to include(class_stub) }

    context "with a constant that is not a moudle" do
      before do
        stub_const("EventHandlers::PI", 3.14)
      end

      it { is_expected.not_to include(3.14) }
    end

    context "with a nested constant that is not a class" do
      before do
        stub_const("EventHandlers::TestHandler::PI", 3.14)
      end

      it { is_expected.not_to include(3.14) }
    end
  end

  describe ".for" do
    subject { described_class.for("test_event", "other_test_event") }

    %w(before after on).each do |type|
      context "with an #{type}_event handler" do
        let(:class_stub) do
          Class.new do
            singleton_class.class_eval do
              define_method(:"#{type}_test_event", -> {})
            end
          end
        end

        before do
          allow(described_class).to receive(:all).and_return([class_stub])
          allow(class_stub).to receive(:"#{type}_test_event")
        end

        it { is_expected.to eq([class_stub]) }
      end
    end

    context "with multiple classes with multiple event handlers" do
      let(:class_stub) do
        Class.new do
          singleton_class.class_eval do
            define_method(:on_test_event, -> {})
          end
        end
      end

      let(:other_class_stub) do
        Class.new do
          singleton_class.class_eval do
            define_method(:before_other_test_event, -> {})
          end
        end
      end

      before do
        allow(described_class).to receive(:all).and_return([class_stub, other_class_stub])
      end

      it { is_expected.to eq([class_stub, other_class_stub]) }
    end

    context "with no handlers" do
      let(:class_stub) { Class.new }

      before do
        allow(described_class).to receive(:all).and_return([class_stub])
      end

      it { is_expected.to eq([]) }
    end
  end
end
