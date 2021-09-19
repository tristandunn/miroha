# frozen_string_literal: true

require "rails_helper"

class BasicAuthenticationTestController < ApplicationController
  include BasicAuthentication
  include Rails.application.routes.url_helpers
end

describe BasicAuthentication do
  describe ".included" do
    subject(:callbacks) { BasicAuthenticationTestController.__callbacks }

    it "includes basic_authentication callback with condition" do
      callback = callbacks[:process_action].find do |action_callback|
        action_callback.filter == :basic_authentication
      end

      expect(callback.instance_variable_get("@if")).to eq(
        [:basic_authentication?]
      )
    end
  end

  describe "#basic_authentication" do
    let(:instance) { BasicAuthenticationTestController.new }
    let(:password) { SecureRandom.hex }
    let(:username) { SecureRandom.hex }

    around do |example|
      ClimateControl.modify(
        BASIC_AUTHENTICATION_USERNAME: username,
        BASIC_AUTHENTICATION_PASSWORD: password
      ) do
        example.run
      end
    end

    it "authenticates with basic authentication" do
      allow(instance).to receive(:authenticate_or_request_with_http_basic)

      instance.basic_authentication

      expect(instance).to have_received(:authenticate_or_request_with_http_basic)
    end

    context "with valid username and password" do
      it "successfully authenticates" do
        allow(instance).to receive(:authenticate_or_request_with_http_basic)
          .and_yield(username, password)

        result = instance.basic_authentication

        expect(result).to eq(true)
      end
    end

    context "with invalid username and password" do
      it "unsuccessfully authenticates" do
        allow(instance).to receive(:authenticate_or_request_with_http_basic)
          .and_yield(SecureRandom.hex, SecureRandom.hex)

        result = instance.basic_authentication

        expect(result).to eq(false)
      end
    end
  end

  describe "#basic_authentication?" do
    subject { instance.basic_authentication? }

    let(:instance) { BasicAuthenticationTestController.new }

    around do |example|
      ClimateControl.modify(
        BASIC_AUTHENTICATION_USERNAME: username,
        BASIC_AUTHENTICATION_PASSWORD: password
      ) do
        example.run
      end
    end

    context "with a username and password" do
      let(:username) { SecureRandom.hex }
      let(:password) { SecureRandom.hex }

      it { is_expected.to eq(true) }
    end

    context "with a username but no password" do
      let(:username) { SecureRandom.hex }
      let(:password) { nil }

      it { is_expected.to eq(false) }
    end

    context "with a password but no username" do
      let(:username) { nil }
      let(:password) { SecureRandom.hex }

      it { is_expected.to eq(false) }
    end

    context "with no username or password" do
      let(:username) { nil }
      let(:password) { nil }

      it { is_expected.to eq(false) }
    end
  end
end
