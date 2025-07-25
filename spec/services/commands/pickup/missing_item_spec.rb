# frozen_string_literal: true

require "rails_helper"

describe Commands::Pickup::MissingItem, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end
end
