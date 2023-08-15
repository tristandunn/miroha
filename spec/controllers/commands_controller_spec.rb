# frozen_string_literal: true

require "rails_helper"

describe CommandsController do
  describe "#create" do
    context "when created successfully" do
      let(:character)   { create(:character) }
      let(:clean_input) { "Hello, world!" }
      let(:raw_input)   { "  Hello,  world!  " }

      let(:command) do
        instance_double(Commands::Unknown, rendered?: false)
      end

      before do
        allow(Command).to receive(:call).and_return(command)

        sign_in_as character

        post :create, params: { input: raw_input }, format: :turbo_stream
      end

      context "with rendering" do
        let(:command) do
          instance_double(
            Commands::Unknown,
            rendered?:      true,
            render_options: {
              partial: "commands/unknown/success"
            }
          )
        end

        it { is_expected.to respond_with(200) }
        it { is_expected.to render_template("commands/unknown/_success") }

        it "calls the command service with cleaned input" do
          expect(Command).to have_received(:call)
            .with(clean_input, character: character)
        end
      end

      context "without rendering" do
        it { is_expected.to respond_with(204) }

        it "calls the command service with cleaned input" do
          expect(Command).to have_received(:call)
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
        allow(Command).to receive(:call)

        sign_in_as character

        post :create, params: { input: "Testing." }
      end

      it { is_expected.to redirect_to(characters_url) }

      it "does not call the command service" do
        expect(Command).not_to have_received(:call)
      end
    end

    context "with no character" do
      before do
        allow(Command).to receive(:call)

        sign_in

        post :create, params: { input: "Testing." }
      end

      it { is_expected.to redirect_to(new_character_url) }

      it "does not call the command service" do
        expect(Command).not_to have_received(:call)
      end
    end

    context "with no input" do
      before do
        allow(Command).to receive(:call)

        sign_in_as create(:character)

        post :create, params: { input: " " }
      end

      it { is_expected.to respond_with(204) }
    end

    context "when signed out" do
      before do
        allow(Command).to receive(:call)

        post :create, params: { input: "Testing." }
      end

      it { is_expected.to redirect_to(new_sessions_url) }

      it "does not call the command service" do
        expect(Command).not_to have_received(:call)
      end
    end
  end
end
