# frozen_string_literal: true

require "rails_helper"

describe Dispatchable do
  let(:class_stub) do
    Class.new do
      include Dispatchable

      def name; end
    end
  end

  describe ".with_event_handlers" do
    it "finds records with the handlers in the database" do
      create_list(:monster, 2)
      aggressive_monster = create(:monster, event_handlers: ["Monster::Hate"])

      expect(Monster.with_event_handlers(:character_attacked)).to eq([aggressive_monster])
    end
  end

  describe "#event_handlers" do
    subject { instance.event_handlers }

    let(:instance) { class_stub.new }

    before do
      class_stub.define_method(:read_attribute, ->(*) {})
    end

    context "with a valid event handler" do
      let(:handler_stub) { double }

      before do
        allow(instance).to receive(:read_attribute).and_return(["ValidName"])
        allow(EventHandlers).to receive(:const_get)
          .with("ValidName", false).and_return(handler_stub)
      end

      it { is_expected.to eq([handler_stub]) }
    end

    context "with an invalid event handler" do
      before do
        allow(instance).to receive(:read_attribute).and_return(["InalidName"])
        allow(EventHandlers).to receive(:const_get)
          .with("InalidName", false).and_raise(NameError)
      end

      it { is_expected.to eq([]) }
    end
  end

  describe "#trigger" do
    let(:instance) { class_stub.new }
    let(:handler)  { Class.new }

    before do
      allow(class_stub).to receive(:name).and_return("ClassStub")
      allow(instance).to receive(:event_handlers).and_return([handler])
    end

    context "with no block" do
      before do
        handler.singleton_class.define_method(:on_test_event, ->(*) {})
      end

      it "forwards to on_event method on the handler" do
        allow(handler).to receive(:on_test_event)

        instance.trigger(:test_event, one: 1, two: 2)

        expect(handler).to have_received(:on_test_event).with(class_stub: instance, one: 1, two: 2)
      end
    end

    context "with a block" do
      before do
        handler.singleton_class.define_method(:after_test_event, ->(*) {})
        handler.singleton_class.define_method(:before_test_event, ->(*) {})
      end

      it "forwards to before_event method on the handler" do
        allow(handler).to receive(:before_test_event)

        instance.trigger(:test_event, one: 1, two: 2) { true }

        expect(handler).to have_received(:before_test_event).with(class_stub: instance, one: 1, two: 2)
      end

      it "yields to the block" do
        expect do |block|
          instance.trigger(:test_event, one: 1, two: 2, &block)
        end.to yield_control
      end

      it "forwards to after_event method on the handler" do
        allow(handler).to receive(:after_test_event)

        instance.trigger(:test_event, one: 1, two: 2) { true }

        expect(handler).to have_received(:after_test_event).with(class_stub: instance, one: 1, two: 2)
      end
    end
  end
end
