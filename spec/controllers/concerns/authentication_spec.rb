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

    it "includes current_character method" do
      expect(helper_methods).to include(:current_character)
    end

    it "includes signed_in? method" do
      expect(helper_methods).to include(:signed_in?)
    end

    it "includes signed_out? method" do
      expect(helper_methods).to include(:signed_out?)
    end
  end

  describe "#access_denied" do
    let(:new_sessions_url) { double }

    before do
      allow(instance).to receive(:redirect_to)
      allow(instance).to receive(:new_sessions_url).and_return(new_sessions_url)
    end

    it "redirects to new_sessions_url" do
      instance.send(:access_denied)

      expect(instance).to have_received(:redirect_to).with(new_sessions_url)
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

  describe "#character_from_session" do
    context "with a character ID in the session" do
      let(:character) { build_stubbed(:character) }
      let(:session)   { { character_id: character.id } }

      before do
        allow(instance).to receive(:current_character=)
        allow(instance).to receive(:session).and_return(session)
        allow(Character).to receive(:find_by).and_return(character)
      end

      it "attempts to find the character" do
        instance.character_from_session

        expect(Character).to have_received(:find_by).with(id: session[:character_id])
      end

      it "returns the character" do
        expect(instance.character_from_session).to eq(character)
      end
    end

    context "with no character ID in the session" do
      let(:session) { {} }

      before do
        allow(instance).to receive(:current_character=)
        allow(instance).to receive(:session).and_return(session)
        allow(Character).to receive(:find_by)
      end

      it "does not attempt to find the character" do
        instance.character_from_session

        expect(Character).not_to have_received(:find_by)
      end

      it "does not assign current_character" do
        instance.character_from_session

        expect(instance).not_to have_received(:current_character=)
      end

      it "returns nil" do
        expect(instance.character_from_session).to be_nil
      end
    end
  end

  describe "#current_account" do
    context "with an account loaded" do
      let(:account) { build_stubbed(:account) }

      before do
        allow(instance).to receive(:account_from_session)

        instance.instance_variable_set(:@current_account, account)
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

        expect(instance.instance_variable_get(:@current_account)).to eq(account)
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

        expect(instance.instance_variable_get(:@current_account)).to be_nil
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
        expect(instance.instance_variable_get(:@current_account)).to eq(account)
      end
    end

    context "when provided nil" do
      let(:session) { {} }

      before do
        instance.current_account = nil
      end

      it "assigns nil to the session" do
        expect(instance.session[:account_id]).to be_nil
      end

      it "assigns nil to instance variable" do
        expect(instance.instance_variable_get(:@current_account)).to be_nil
      end
    end
  end

  describe "#current_character" do
    context "with a character loaded" do
      let(:character) { build_stubbed(:character) }

      before do
        allow(instance).to receive(:character_from_session)

        instance.instance_variable_set(:@current_character, character)
      end

      it "does not attempt to load a character from the session" do
        instance.current_character

        expect(instance).not_to have_received(:character_from_session)
      end

      it "returns the character" do
        expect(instance.current_character).to eq(character)
      end
    end

    context "with a character in the session" do
      let(:character) { build_stubbed(:character) }

      before do
        allow(instance).to receive(:character_from_session).and_return(character)
      end

      it "loads the character from the session once" do
        instance.current_character
        instance.current_character

        expect(instance).to have_received(:character_from_session).once
      end

      it "assigns the character to the instance variable" do
        instance.current_character

        expect(instance.instance_variable_get(:@current_character)).to eq(character)
      end

      it "returns the character" do
        expect(instance.current_character).to eq(character)
      end
    end

    context "with no character in the session" do
      before do
        allow(instance).to receive(:character_from_session).and_return(nil)
      end

      it "attempts to load a character from the session once" do
        instance.current_character
        instance.current_character

        expect(instance).to have_received(:character_from_session).once
      end

      it "assigns nil to the instance variable" do
        instance.current_character

        expect(instance.instance_variable_get(:@current_character)).to be_nil
      end

      it "returns unknown character" do
        expect(instance.current_character).to be_nil
      end
    end
  end

  describe "#current_character=" do
    context "when assigned a character" do
      let(:character) { build_stubbed(:character) }
      let(:session)   { {} }

      before do
        allow(instance).to receive(:session).and_return(session)

        instance.current_character = character
      end

      it "assigns the character ID to the session" do
        expect(instance.session[:character_id]).to eq(character.id)
      end

      it "assigns the character to the instance variable" do
        expect(instance.instance_variable_get(:@current_character)).to eq(character)
      end
    end

    context "when assigned nil" do
      let(:session) { {} }

      before do
        allow(instance).to receive(:session).and_return(session)

        instance.current_character = nil
      end

      it "assigns nil to the session" do
        expect(instance.session[:account_id]).to be_nil
      end

      it "assigns nil to instance variable" do
        expect(instance.instance_variable_get(:@current_character)).to be_nil
      end
    end
  end

  describe "#current_character?" do
    context "with a character is present" do
      let(:character) { build_stubbed(:character) }

      before do
        allow(instance).to receive(:current_character).and_return(character)
      end

      it "returns true" do
        expect(instance).to be_current_character
      end
    end

    context "with no character is present" do
      before do
        allow(instance).to receive(:current_character).and_return(nil)
      end

      it "returns false" do
        expect(instance).not_to be_current_character
      end
    end
  end

  describe "#require_active_character" do
    context "with a character present" do
      let(:character) { build_stubbed(:character) }

      before do
        allow(instance).to receive(:redirect_to)
        allow(instance).to receive(:current_character).and_return(character)
      end

      it "does not call redirect_to" do
        instance.require_active_character

        expect(instance).not_to have_received(:redirect_to)
      end
    end

    context "with an inactive character present" do
      let(:character)      { build_stubbed(:character, :inactive) }
      let(:characters_url) { double }

      before do
        allow(instance).to receive(:redirect_to)
        allow(instance).to receive(:current_character).and_return(character)
        allow(instance).to receive(:characters_url).and_return(characters_url)
      end

      it "redirects to characters_url" do
        instance.require_active_character

        expect(instance).to have_received(:redirect_to).with(characters_url)
      end
    end

    context "with no character present" do
      let(:new_character_url) { double }

      before do
        allow(instance).to receive(:redirect_to)
        allow(instance).to receive(:current_character).and_return(nil)
        allow(instance).to receive(:new_character_url).and_return(new_character_url)
      end

      it "redirects to new_character_url" do
        instance.require_active_character

        expect(instance).to have_received(:redirect_to).with(new_character_url)
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
