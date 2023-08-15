# frozen_string_literal: true

require "rails_helper"

describe Commands::Look::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { instance_double(Character, room: room) }
    let(:instance)  { described_class.new(character: character, object: object) }

    context "with no object" do
      let(:room)   { build_stubbed(:room) }
      let(:object) { nil }

      it { is_expected.to eq(description: room.description) }
    end

    context "with a valid object" do
      let(:description) { Faker::Lorem.sentence }
      let(:room)        { build_stubbed(:room, objects: { object => description }) }
      let(:object)      { Faker::Lorem.word }

      it { is_expected.to eq(description: description) }
    end

    context "with an invalid object" do
      let(:object) { Faker::Lorem.word }
      let(:room)   { build_stubbed(:room) }

      let(:description) do
        I18n.t(
          "commands.look.unknown",
          article: object.indefinite_article,
          target:  object
        )
      end

      it { is_expected.to eq(description: description) }
    end
  end
end
