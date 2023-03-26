# frozen_string_literal: true

require "rails_helper"

describe Commands::LookCommand, type: :service do
  let(:character) { build_stubbed(:character, room: room) }
  let(:object)    { nil }
  let(:room)      { build_stubbed(:room) }
  let(:instance)  { described_class.new("/look #{object}", character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    it { is_expected.to be_nil }

    it "does not broadcast" do
      call

      expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
    end
  end

  describe "#rendered?" do
    subject { instance.rendered? }

    it { is_expected.to be(true) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    context "with no object" do
      it "returns the partial with the room description as a local" do
        expect(render_options).to eq(
          partial: "commands/look",
          locals:  {
            description: room.description
          }
        )
      end
    end

    context "with a valid object" do
      let(:description) { Faker::Lorem.sentence }
      let(:object)      { Faker::Lorem.word }
      let(:room)        { build_stubbed(:room, objects: { object => description }) }

      it "returns the partial with the object description as a local" do
        expect(render_options).to eq(
          partial: "commands/look",
          locals:  {
            description: description
          }
        )
      end
    end

    context "with an invalid object" do
      let(:object)      { Faker::Lorem.word }
      let(:room)        { build_stubbed(:room) }

      it "returns the partial with the object description as a local" do
        expect(render_options).to eq(
          partial: "commands/look",
          locals:  {
            description: I18n.t(
              "commands.look.unknown",
              article: object.indefinite_article,
              target:  object
            )
          }
        )
      end
    end
  end
end
