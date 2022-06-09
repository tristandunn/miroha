# frozen_string_literal: true

require "rails_helper"

describe Clock, type: :service do
  it { is_expected.to delegate_method(:pause).to(:scheduler) }

  describe ".scheduler" do
    subject { described_class.scheduler }

    let(:singleton) { instance_double(Rufus::Scheduler) }

    before do
      allow(Rufus::Scheduler).to receive(:singleton).and_return(singleton)
    end

    it { is_expected.to eq(singleton) }
  end

  describe ".start" do
    subject(:start) { described_class.start }

    let(:scheduler) { instance_double(Rufus::Scheduler) }

    before do
      allow(described_class).to receive(:constants).with(false).and_return(constants)
      allow(described_class).to receive(:scheduler).and_return(scheduler)
    end

    context "with a callable clock service" do
      let(:constants) { [:ActivateSpawns] }
      let(:instance)  { service.new }
      let(:service)   { Clock::ActivateSpawns }

      it "schedules the service" do
        allow(scheduler).to receive(:every)

        start

        expect(scheduler).to have_received(:every)
          .with(instance.interval, instance_of(service), name: instance.name)
      end
    end

    context "with a non-callback clock service" do
      let(:constants) { [:Base] }

      it "does not schedule the service" do
        start

        expect(described_class).not_to have_received(:scheduler)
      end
    end
  end

  describe ".join" do
    subject(:join) { described_class.join }

    let(:scheduler) { instance_double(Rufus::Scheduler) }

    before do
      allow(Signal).to receive(:trap)
      allow(scheduler).to receive(:join)
      allow(described_class).to receive(:scheduler).and_return(scheduler)
    end

    it "traps the INT signal" do
      join

      expect(Signal).to have_received(:trap).with("INT")
    end

    it "traps the TERM signal" do
      join

      expect(Signal).to have_received(:trap).with("TERM")
    end

    it "calls join on the scheduler" do
      join

      expect(scheduler).to have_received(:join)
    end

    context "when a signal is trapped" do
      before do
        allow(Signal).to receive(:trap).and_yield
        allow(scheduler).to receive(:shutdown)
      end

      it "shuts down the scheduler with a wait" do
        join

        expect(scheduler).to have_received(:shutdown).with(wait: 29).twice
      end

      it "uses wait time from environment variable" do
        ClimateControl.modify(CLOCK_SHUTDOWN_WAIT_SECONDS: "7") do
          join
        end

        expect(scheduler).to have_received(:shutdown).with(wait: 7).twice
      end
    end
  end
end
