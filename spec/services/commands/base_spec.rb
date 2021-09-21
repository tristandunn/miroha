# frozen_string_literal: true

require "rails_helper"

describe Commands::Base, type: :service do
  let(:character) { build_stubbed(:character) }

  describe "#call" do
    it "returns nil" do
      instance = described_class.new("", character: character)

      result = instance.call

      expect(result).to eq(nil)
    end
  end

  describe "#render?" do
    it "returns false" do
      instance = described_class.new("", character: character)

      expect(instance).not_to be_rendered
    end
  end

  describe "#render_options" do
    it "returns the partial with no locals" do
      instance = described_class.new("", character: character)

      result = instance.render_options

      expect(result).to eq(
        partial: "commands/base",
        locals:  {}
      )
    end
  end
end
