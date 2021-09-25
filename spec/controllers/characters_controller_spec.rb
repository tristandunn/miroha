# frozen_string_literal: true

require "rails_helper"

describe CharactersController, type: :controller do
  it { is_expected.to be_a(ApplicationController) }

  describe "#index" do
    context "when signed in" do
      let(:account)   { character.account }
      let(:character) { create(:character) }

      before do
        create(:character)

        sign_in_as account

        get :index
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:index) }

      it "assigns the characters from the current account" do
        expect(assigns(:characters)).to eq([character])
      end
    end

    context "when signed out" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(new_sessions_url) }
    end
  end

  describe "#new" do
    context "when signed in" do
      let(:account) { create(:account) }

      before do
        sign_in_as account

        get :new
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:new) }

      it "assigns a form" do
        expect(assigns(:form)).to be_a(CharacterForm)
      end
    end

    context "when signed out" do
      before do
        get :new
      end

      it { is_expected.to redirect_to(new_sessions_url) }
    end

    context "when at the character limit" do
      let(:account) { create(:account) }

      before do
        create_list(:character, Account::CHARACTER_LIMIT, account: account)

        sign_in_as account

        get :new
      end

      it { is_expected.to redirect_to(characters_url) }
    end
  end

  describe "#create" do
    context "when created successfully" do
      let(:account)   { create(:account) }
      let(:character) { form.character }
      let(:form)      { assigns(:form) }

      before do
        create(:room)

        sign_in_as account

        post :create, params: {
          character_form: {
            name: generate(:name)
          }
        }
      end

      it { is_expected.to set_session[:character_id].to(character.id) }
      it { is_expected.to redirect_to(root_url) }

      it "creates a character" do
        expect(character).to be_an(Character).and(be_persisted)
      end
    end

    context "when not created successfully" do
      let(:account)   { create(:account) }
      let(:character) { form.character }
      let(:form)      { assigns(:form) }

      before do
        sign_in_as account

        post :create, params: { character_form: { name: "" } }
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:new) }
      it { is_expected.not_to set_session[:character_id] }

      it "assigns the character" do
        expect(character).to be_a(Character)
      end
    end

    context "when signed out" do
      before do
        post :create
      end

      it { is_expected.to redirect_to(new_sessions_url) }
    end

    context "when at the character limit" do
      let(:account) { create(:account) }

      before do
        create_list(:character, Account::CHARACTER_LIMIT, account: account)

        sign_in_as account

        post :create
      end

      it { is_expected.to redirect_to(characters_url) }
    end
  end

  describe "#select" do
    context "when selected successfully" do
      let(:account)   { character.account }
      let(:character) { create(:character, :inactive) }

      before do
        allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)

        sign_in_as account

        post :select, params: { id: character.id }
      end

      it { is_expected.to set_session[:character_id].to(character.id) }
      it { is_expected.to redirect_to(root_url) }

      it "marks the character is active", :freeze_time do
        expect(character.reload.active_at).to eq(Time.current)
      end

      it "broadcasts an enter message to the room" do
        expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
          .with(
            character.room,
            partial: "characters/enter",
            locals:  {
              character: character
            }
          )
      end
    end

    context "when not selected successfully" do
      let(:account) { create(:account) }

      before do
        allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)

        sign_in_as account

        post :select, params: { id: 1 }
      end

      it { is_expected.not_to set_session[:character_id] }
      it { is_expected.to redirect_to(characters_url) }

      it "does not broadcast an enter message to the room" do
        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_render_later_to)
      end
    end

    context "when signed out" do
      before do
        post :select, params: { id: 1 }
      end

      it { is_expected.to redirect_to(new_sessions_url) }
    end
  end

  describe "#exit" do
    context "when exiting successfully" do
      let(:character) { create(:character) }

      before do
        allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)

        sign_in_as character

        post :exit
      end

      it { is_expected.to set_session[:character_id].to(nil) }
      it { is_expected.to redirect_to(characters_url) }

      it "broadcasts an exit message to the room" do
        expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
          .with(
            character.room,
            partial: "characters/exit",
            locals:  {
              character: character
            }
          )
      end
    end

    context "when signed out" do
      before do
        post :exit
      end

      it { is_expected.to redirect_to(new_sessions_url) }
    end
  end
end
