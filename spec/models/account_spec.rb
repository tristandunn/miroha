# frozen_string_literal: true

require "rails_helper"

describe Account do
  describe "associations" do
    it { is_expected.to have_many(:characters).dependent(:destroy) }
  end

  describe "validations" do
    subject(:account) { build(:account) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value("MrBoB@example.com").for(:email) }
    it { is_expected.not_to allow_value("@.com").for(:email) }

    it { is_expected.to validate_presence_of(:password).on(:update) }

    it "is expected to validate that the length of :email is at most the maximum" do
      expect(account).to validate_length_of(:email)
        .is_at_most(described_class::MAXIMUM_EMAIL_LENGTH)
    end

    it "is expected to validate that the length of :password is at least the minimum" do
      expect(account).to validate_length_of(:password)
        .is_at_least(described_class::MINIMUM_PASSWORD_LENGTH)
    end
  end

  describe "#assign_default_aliases" do
    subject(:account) { create(:account, aliases: {}) }

    it "assigns the default alaises" do
      expect(account.aliases).to eq(described_class::DEFAULT_ALIASES)
    end
  end

  describe "#can_create_character?" do
    subject { account.can_create_character? }

    let(:account) { create(:account) }

    context "with no characters" do
      it { is_expected.to be(true) }
    end

    context "with characters at the limit" do
      before do
        create_list(:character, described_class::CHARACTER_LIMIT, account: account)
      end

      it { is_expected.to be(false) }
    end
  end

  describe "#format_attributes" do
    subject(:account) { create(:account, email: "  AN@EXAMPLE.COM  ") }

    it "downcases and strips e-mail" do
      expect(account.email).to eq("an@example.com")
    end
  end
end
