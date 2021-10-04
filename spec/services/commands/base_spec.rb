# frozen_string_literal: true

require "rails_helper"

describe Commands::Base, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("", character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    it { is_expected.to eq(nil) }
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    it { is_expected.to eq(false) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    it "returns the partial with no locals" do
      expect(render_options).to eq(
        partial: "commands/base",
        locals:  {}
      )
    end
  end
end
