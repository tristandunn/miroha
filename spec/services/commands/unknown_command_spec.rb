# frozen_string_literal: true

require "rails_helper"

describe Commands::UnknownCommand, type: :service do
  let(:character) { build_stubbed(:character) }

  describe "#call" do
    it "does not broadcast" do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
      instance = described_class.new("/unknown", character: character)

      instance.call

      expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
    end

    it "returns nil" do
      instance = described_class.new("/unknown", character: character)

      result = instance.call

      expect(result).to eq(nil)
    end
  end

  describe "#render?" do
    it "returns true" do
      instance = described_class.new("/unknown", character: character)

      expect(instance).to be_rendered
    end
  end

  describe "#render_options" do
    it "returns the partial with command locals" do
      instance = described_class.new("/unknown command", character: character)

      result = instance.render_options

      expect(result).to eq(
        partial: "commands/unknown",
        locals:  {
          command: "/unknown command"
        }
      )
    end
  end
end
