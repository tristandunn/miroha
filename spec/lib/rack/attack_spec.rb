# frozen_string_literal: true

require "rails_helper"

describe Rack::Attack do
  subject(:call) { throttle.block.call(request) }

  describe "accounts/create" do
    let(:throttle) { described_class.throttles["accounts/create"] }

    it "defines a limit and period" do
      expect(throttle).to have_attributes(limit: 5, period: 60)
    end

    context "with a POST to /accounts" do
      let(:request) do
        instance_double(Rack::Attack::Request, ip: "1.2.3.4", path: "/accounts", post?: true)
      end

      it { is_expected.to eq(request.ip) }
    end

    context "with other requests" do
      let(:request) do
        instance_double(Rack::Attack::Request, path: "/sessions", post?: false)
      end

      it { is_expected.to be_nil }
    end
  end

  describe "accounts/command" do
    let(:throttle) { described_class.throttles["accounts/command"] }

    context "with a dynamic limit" do
      let(:command) { class_double(Commands::Base, limit: limit) }
      let(:limit)   { rand }
      let(:request) { instance_double(Rack::Attack::Request, env: { "miroha.command" => command }) }

      it "returns limit from the command" do
        expect(throttle.limit.call(request)).to eq(limit)
      end
    end

    context "with a dynamic period" do
      let(:command) { class_double(Commands::Base, period: period) }
      let(:period)  { rand }
      let(:request) { instance_double(Rack::Attack::Request, env: { "miroha.command" => command }) }

      it "returns period from the command" do
        expect(throttle.period.call(request)).to eq(period)
      end
    end

    context "with a POST to /commands" do
      let(:account_id) { rand }
      let(:command)    { stub_const("Commands::Test::Example", Class.new) }
      let(:input)      { double }

      let(:request) do
        instance_double(
          Rack::Attack::Request,
          env:     {},
          params:  { "input" => input },
          path:    "/commands",
          post?:   true,
          session: { "account_id" => account_id }
        )
      end

      before do
        allow(Command).to receive(:parse).with(input).and_return(command)
      end

      it "assigns the command to the environment" do
        call

        expect(request.env["miroha.command"]).to eq(command)
      end

      it { is_expected.to eq("#{account_id}/test/example") }
    end

    context "with other requests" do
      let(:request) do
        instance_double(Rack::Attack::Request, path: "/commands", post?: false)
      end

      it { is_expected.to be_nil }
    end
  end

  describe "sessions/email" do
    subject { throttle.block.call(request) }

    let(:throttle) { described_class.throttles["sessions/email"] }

    it "defines a limit and period" do
      expect(throttle).to have_attributes(limit: 5, period: 60)
    end

    context "with a POST to /sessions" do
      let(:params) { { "session_form" => { "email" => " BOB@example.com " } } }

      let(:request) do
        instance_double(Rack::Attack::Request, params: params, path: "/sessions", post?: true)
      end

      it { is_expected.to eq("bob@example.com") }
    end

    context "with other requests" do
      let(:request) do
        instance_double(Rack::Attack::Request, path: "/sessions", post?: false)
      end

      it { is_expected.to be_nil }
    end
  end

  describe "sessions/ip" do
    subject { throttle.block.call(request) }

    let(:throttle) { described_class.throttles["sessions/ip"] }

    it "defines a limit and period" do
      expect(throttle).to have_attributes(limit: 1, period: 1)
    end

    context "with a POST to /sessions" do
      let(:request) do
        instance_double(Rack::Attack::Request, ip: "1.2.3.4", path: "/sessions", post?: true)
      end

      it { is_expected.to eq(request.ip) }
    end

    context "with other requests" do
      let(:request) do
        instance_double(Rack::Attack::Request, path: "/sessions", post?: false)
      end

      it { is_expected.to be_nil }
    end
  end
end
