# frozen_string_literal: true

require "rails_helper"

describe AccountForm, type: :form do
  subject(:form) { described_class.new(attributes_for(:account)) }

  describe "#account" do
    it "builds a new account with the form attributes" do
      expect(form.account).to be_a(Account).and(be_new_record).and(
        have_attributes(
          email:    form.email,
          password: form.password
        )
      )
    end
  end

  describe "#save" do
    context "when valid" do
      it "persists the account" do
        form.save

        expect(form.account).to be_persisted
      end
    end

    context "when invalid" do
      before do
        create(:account, email: form.email)
      end

      it "does not persist the account" do
        form.save

        expect(form.account).not_to be_persisted
      end

      it "merges account errors" do
        form.save

        expect(form.errors.messages[:email]).to eq([t("errors.messages.taken")])
      end
    end
  end
end
