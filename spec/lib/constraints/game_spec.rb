# frozen_string_literal: true

require "rails_helper"

describe Constraints::Game do
  describe ".matches?" do
    subject { described_class.matches?(request) }

    let(:request) do
      instance_double(ActionDispatch::Request, session: session)
    end

    context "with a character ID in the session" do
      let(:session) { { character_id: SecureRandom.uuid } }

      it { is_expected.to be(true) }
    end

    context "without a character ID in the session" do
      let(:session) { {} }

      it { is_expected.to be(false) }
    end
  end
end
