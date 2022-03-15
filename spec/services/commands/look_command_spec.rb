# frozen_string_literal: true

require "rails_helper"

describe Commands::LookCommand, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("/look", character: character) }

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

    it "returns the partial with the character room as a local" do
      expect(render_options).to eq(
        partial: "commands/look",
        locals:  {
          room: character.room
        }
      )
    end
  end
end
