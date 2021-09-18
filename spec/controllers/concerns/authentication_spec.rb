# frozen_string_literal: true

require "rails_helper"

class AuthenticationTestController < ApplicationController
  include Authentication
  include Rails.application.routes.url_helpers
end

describe Authentication do
  let(:instance) { AuthenticationTestController.new }

  describe ".included" do
    subject(:helper_methods) { AuthenticationTestController._helper_methods }

    it "includes current_account method" do
      expect(helper_methods).to include(:current_account)
    end

    it "includes signed_in? method" do
      expect(helper_methods).to include(:signed_in?)
    end

    it "includes signed_out? method" do
      expect(helper_methods).to include(:signed_out?)
    end
  end

  describe "#access_denied" do
    let(:root_url) { double }

    before do
      allow(instance).to receive(:redirect_to)
      allow(instance).to receive(:root_url).and_return(root_url)
    end

    it "redirects to root_url" do
      instance.send(:access_denied)

      expect(instance).to have_received(:redirect_to).with(root_url)
    end
  end

  describe "#account_from_session" do
    context "with an account ID in the session" do
      let(:account) { build_stubbed(:account) }
      let(:session) { { account_id: account.id } }

      before do
        allow(instance).to receive(:current_account=)
        allow(instance).to receive(:session).and_return(session)

        allow(Account).to receive(:find_by).and_return(account)
      end

      it "attempts to find the account" do
        instance.account_from_session

        expect(Account).to have_received(:find_by).with(id: session[:account_id])
      end

      it "returns the account" do
        expect(instance.account_from_session).to eq(account)
      end
    end

    context "with no account ID in the session" do
      let(:session) { {} }

      before do
        allow(instance).to receive(:current_account=)
        allow(instance).to receive(:session).and_return(session)

        allow(Account).to receive(:find_by)
      end

      it "does not attempt to find the account" do
        instance.account_from_session

        expect(Account).not_to have_received(:find_by)
      end

      it "does not assign current_account" do
        instance.account_from_session

        expect(instance).not_to have_received(:current_account=)
      end

      it "returns nil" do
        expect(instance.account_from_session).to be_nil
      end
    end
  end

  describe "#authenticate" do
    context "when signed in" do
      before do
        allow(instance).to receive(:access_denied)
        allow(instance).to receive(:signed_out?).and_return(false)
      end

      it "does not call access_denied" do
        instance.authenticate

        expect(instance).not_to have_received(:access_denied)
      end
    end

    context "when signed out" do
      before do
        allow(instance).to receive(:access_denied)
        allow(instance).to receive(:signed_out?).and_return(true)
      end

      it "calls access_denied" do
        instance.authenticate

        expect(instance).to have_received(:access_denied).with(no_args)
      end
    end
  end

  describe "#current_account" do
    context "with an account loaded" do
      let(:account) { build_stubbed(:account) }

      before do
        allow(instance).to receive(:account_from_session)

        instance.instance_variable_set("@current_account", account)
      end

      it "does not attempt to load an account from the session" do
        instance.current_account

        expect(instance).not_to have_received(:account_from_session)
      end

      it "returns the account" do
        expect(instance.current_account).to eq(account)
      end
    end

    context "with an account in the session" do
      let(:account) { build_stubbed(:account) }

      before do
        allow(instance).to receive(:account_from_session).and_return(account)
      end

      it "loads the account from the session once" do
        instance.current_account
        instance.current_account

        expect(instance).to have_received(:account_from_session).once
      end

      it "assigns the account to the instance variable" do
        instance.current_account

        expect(instance.instance_variable_get("@current_account")).to eq(account)
      end

      it "returns the account" do
        expect(instance.current_account).to eq(account)
      end
    end

    context "with no account in the session" do
      before do
        allow(instance).to receive(:account_from_session).and_return(nil)
      end

      it "attempts to load an account from the session once" do
        instance.current_account
        instance.current_account

        expect(instance).to have_received(:account_from_session).once
      end

      it "assigns nil to the instance variable" do
        instance.current_account

        expect(instance.instance_variable_get("@current_account")).to be_nil
      end

      it "returns unknown account" do
        expect(instance.current_account).to be_nil
      end
    end
  end

  describe "#current_account=" do
    before do
      allow(instance).to receive(:session).and_return(session)
    end

    context "when provided an account" do
      let(:account) { build_stubbed(:account) }
      let(:session) { {} }

      before do
        instance.current_account = account
      end

      it "assigns the account ID to the session" do
        expect(instance.session[:account_id]).to eq(account.id)
      end

      it "assigns the account to the instance variable" do
        expect(instance.instance_variable_get("@current_account")).to eq(account)
      end
    end

    context "when provided nil" do
      let(:session) { {} }

      before do
        instance.current_account = nil
      end

      it "assigns nil to session" do
        expect(instance.session[:account_id]).to be_nil
      end

      it "assigns nil to instance variable" do
        expect(instance.instance_variable_get("@current_account")).to be_nil
      end
    end
  end

  describe "#signed_in?" do
    context "with an account present" do
      let(:account) { build_stubbed(:account) }

      before do
        allow(instance).to receive(:current_account).and_return(account)
      end

      it "returns true" do
        expect(instance).to be_signed_in
      end
    end

    context "with no account present" do
      before do
        allow(instance).to receive(:current_account).and_return(nil)
      end

      it "returns false" do
        expect(instance).not_to be_signed_in
      end
    end
  end

  describe "#signed_out?" do
    context "with an account present" do
      let(:account) { build_stubbed(:account) }

      before do
        allow(instance).to receive(:current_account).and_return(account)
      end

      it "returns false" do
        expect(instance).not_to be_signed_out
      end
    end

    context "with no account present" do
      before do
        allow(instance).to receive(:current_account).and_return(nil)
      end

      it "returns true" do
        expect(instance).to be_signed_out
      end
    end
  end
end
