# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("/alias", character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    it "does not broadcast" do
      call

      expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
    end

    it "returns nil" do
      expect(call).to be_nil
    end
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    it { is_expected.to be(true) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    it "returns the partial with aliases locals" do
      expect(render_options).to eq(
        partial: "commands/alias",
        locals:  {
          aliases: character.account.aliases
        }
      )
    end
  end
end
