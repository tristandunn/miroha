# frozen_string_literal: true

require "rails_helper"

describe ApplicationRecord, type: :model do
  describe "class" do
    subject(:klass) { described_class }

    it "inherits from ActiveRecord base" do
      expect(klass.superclass).to eq(ActiveRecord::Base)
    end
  end
end
