# frozen_string_literal: true

require "rails_helper"

describe CommandsController do
  describe "#create" do
    context "when created successfully" do
      let(:character)     { create(:character) }
      let(:clean_input)   { "Hello, world!" }
      let(:command)       { instance_double(command_class, call: true, rendered?: false) }
      let(:command_class) { Commands::Unknown }
      let(:limit)         { 1 }

      before do
        allow(command_class).to receive(:new).with(clean_input, character: character).and_return(command)
        allow(Command::Parser).to receive(:call).with(clean_input).and_return(command_class)
        allow(controller).to receive(:rate_limiting).and_call_original
        allow(controller.cache_store).to receive(:increment).and_return(limit)

        sign_in_as character

        post :create, params: { input: "  Hello,  world!  " }, format: :turbo_stream
      end

      context "with rendering" do
        let(:command) do
          instance_double(
            command_class,
            call:           true,
            rendered?:      true,
            render_options: {
              partial: "commands/unknown/success"
            }
          )
        end

        it { is_expected.to respond_with(200) }
        it { is_expected.to render_template("commands/unknown/_success") }

        it "creates a command class with cleaned input" do
          expect(command_class).to have_received(:new)
            .with(clean_input, character: character)
        end

        it "enforces rate limiting" do
          expect(controller).to have_received(:rate_limiting)
            .with(hash_including(to: command_class.limit, within: command_class.period))
        end

        it "tracks rate limiting by account and command" do
          expect(controller.cache_store).to have_received(:increment).with(
            "rate-limit:commands:account-#{character.account_id}:unknown",
            1,
            expires_in: command_class.period
          )
        end
      end

      context "when rate limited" do
        let(:limit) { 999 }

        it { is_expected.to respond_with(429) }
      end

      context "without rendering" do
        it { is_expected.to respond_with(204) }

        it "creates a command class with cleaned input" do
          expect(command_class).to have_received(:new)
            .with(clean_input, character: character)
        end
      end

      context "when recently active", :freeze_time do
        let(:character) { create(:character, active_at: 25.seconds.ago) }

        it "does not mark the character is active" do
          expect(character.reload.active_at).not_to eq(Time.current)
        end
      end

      context "when not recently active", :freeze_time do
        let(:character) { create(:character, active_at: 45.seconds.ago) }

        it "marks the character is active" do
          expect(character.reload.active_at).to eq(Time.current)
        end
      end
    end

    context "with an inactive character" do
      let(:character) { create(:character, :inactive) }

      before do
        allow(Command::Parser).to receive(:call)

        sign_in_as character

        post :create, params: { input: "Testing." }
      end

      it { is_expected.to redirect_to(characters_url) }

      it "does not call the command parser service" do
        expect(Command::Parser).not_to have_received(:call)
      end
    end

    context "with no character" do
      before do
        allow(Command::Parser).to receive(:call)

        sign_in

        post :create, params: { input: "Testing." }
      end

      it { is_expected.to redirect_to(new_character_url) }

      it "does not call the command parser service" do
        expect(Command::Parser).not_to have_received(:call)
      end
    end

    context "with no input" do
      before do
        allow(Command::Parser).to receive(:call)

        sign_in_as create(:character)

        post :create, params: { input: " " }
      end

      it { is_expected.to respond_with(204) }
    end

    context "when signed out" do
      before do
        allow(Command::Parser).to receive(:call)

        post :create, params: { input: "Testing." }
      end

      it { is_expected.to redirect_to(new_sessions_url) }

      it "does not call the command parser service" do
        expect(Command::Parser).not_to have_received(:call)
      end
    end
  end
end
