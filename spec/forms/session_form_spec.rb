# frozen_string_literal: true

require "rails_helper"

describe SessionForm, type: :model do
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_presence_of(:password) }

  describe "#initialize" do
    subject(:session) { described_class.new(email: email, password: password) }

    let(:email)    { generate(:email) }
    let(:password) { generate(:password) }

    it "assigns the e-mail" do
      expect(session.email).to eq(email)
    end

    it "assigns the password" do
      expect(session.password).to eq(password)
    end
  end

  describe "#account" do
    subject(:session) { described_class.new(email: email) }

    let(:account) { create(:account) }

    context "with a matching account" do
      let(:email) { account.email }

      it "returns the account" do
        expect(session.account).to eq(account)
      end
    end

    context "with an unknown account" do
      let(:email) { generate(:email) }

      it "returns nil" do
        expect(session.account).to be_nil
      end
    end

    context "with a blank e-mail" do
      let(:email) { "" }

      before do
        allow(Account).to receive(:find_by)
      end

      it "does not attempt to find the account" do
        session.account

        expect(Account).not_to have_received(:find_by)
      end

      it "returns nil" do
        expect(session.account).to be_nil
      end
    end

    context "with an oddly formatted e-mail" do
      let(:email) { "  AN@EXAMPLE.COM  " }

      before do
        allow(Account).to receive(:find_by)
      end

      it "downcases and strips the e-mail for the query" do
        session.account

        expect(Account).to have_received(:find_by).with(email: "an@example.com")
      end
    end
  end

  describe "#persisted?" do
    subject(:session) { described_class.new }

    it "returns false" do
      expect(session.persisted?).to be(false)
    end
  end

  describe "#validate_account_and_password" do
    subject(:session) { described_class.new(email: email, password: password) }

    let(:account) { create(:account) }

    before do
      session.valid?
    end

    context "with a valid account and password" do
      let(:email)    { account.email }
      let(:password) { account.password }

      it "is valid" do
        expect(session).to be_valid
      end

      it "does not add errors" do
        expect(session.errors).to be_empty
      end
    end

    context "without an account" do
      let(:email)    { "fake@example.com" }
      let(:password) { generate(:password) }

      it "is not valid" do
        expect(session).not_to be_valid
      end

      it "adds an error message for e-mail" do
        expect(session.errors[:email]).to eq(
          [t("activemodel.errors.models.session_form.attributes.email.unknown")]
        )
      end
    end

    context "with an invalid password" do
      let(:email)    { account.email }
      let(:password) { "wrong" }

      it "is not valid" do
        expect(session).not_to be_valid
      end

      it "adds an error message for password" do
        expect(session.errors[:password]).to eq(
          [t("activemodel.errors.models.session_form.attributes.password.incorrect")]
        )
      end
    end
  end
end
