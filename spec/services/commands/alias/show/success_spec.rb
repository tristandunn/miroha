# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias::Show::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:aliases)  { { "u" => "/move up" } }
    let(:instance) { described_class.new(aliases: aliases) }

    it { is_expected.to eq(aliases: aliases) }
  end
end
