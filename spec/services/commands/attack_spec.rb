# frozen_string_literal: true

require "rails_helper"

describe Commands::Attack, type: :service do
  let(:character) { create(:character, room: target.room) }
  let(:damage)    { 1 }
  let(:instance)  { described_class.new("/attack #{target.name}", character: character) }
  let(:target)    { create(:spawn, :monster).entity }

  before do
    allow(SecureRandom).to receive(:random_number).with(0..1).and_return(damage).once
  end

  describe "#call" do
    subject(:call) { instance.call }

    context "with a valid, hit target" do
      let(:result) { instance_double(described_class::Hit) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Hit).to receive(:new)
          .with(character: character, damage: damage, target: target)
          .and_return(result)
      end

      it "delegates to hit handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with a valid, hit target using a partial name" do
      let(:instance) { described_class.new("/attack #{target.name.slice(1)}", character: character) }
      let(:result)   { instance_double(described_class::Hit) }

      before do
        first_target = create(:monster, room: target.room, name: target.name)
        create(:spawn, :monster, entity: first_target, room: target.room)

        target.update(id: Monster.last.id + 1)

        allow(result).to receive(:call)
        allow(described_class::Hit).to receive(:new)
          .with(character: character, damage: damage, target: first_target)
          .and_return(result)
      end

      it "delegates to hit handler for the first matching target" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with a valid, missed target" do
      let(:damage) { 0 }
      let(:result) { instance_double(described_class::Missed) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Missed).to receive(:new)
          .with(character: character, target: target)
          .and_return(result)
      end

      it "delegates to miss handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with a valid, killed target" do
      let(:result) { instance_double(described_class::Killed) }

      before do
        target.update!(current_health: 1, experience: 5)

        allow(result).to receive(:call)
        allow(described_class::Killed).to receive(:new)
          .with(character: character, damage: damage, target: target)
          .and_return(result)
      end

      it "delegates to killed handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with target in a different room" do
      let(:character) { create(:character) }
      let(:result)    { instance_double(described_class::InvalidTarget) }

      before do
        allow(result).to receive(:call)
        allow(described_class::InvalidTarget).to receive(:new)
          .with(target_name: target.name)
          .and_return(result)
      end

      it "delegates to invalid target handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with invalid target" do
      let(:instance) { described_class.new("/attack Invalid", character: character) }
      let(:result)   { instance_double(described_class::InvalidTarget) }

      before do
        allow(result).to receive(:call)
        allow(described_class::InvalidTarget).to receive(:new)
          .with(target_name: "Invalid")
          .and_return(result)
      end

      it "delegates to invalid target handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with blank target" do
      let(:instance) { described_class.new("/attack ", character: character) }
      let(:result)   { instance_double(described_class::MissingTarget) }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingTarget).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to missing target handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end
