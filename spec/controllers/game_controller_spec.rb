# frozen_string_literal: true

require "rails_helper"

describe GameController do
  describe "#index" do
    context "with a valid character ID" do
      let(:character) { create(:character) }

      before do
        sign_in_as character

        get :index
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template("game/index", layout: "game") }

      it "assigns the current character" do
        expect(assigns(:character)).to eq(character)
      end
    end

    context "with an inactive character" do
      let(:character) { create(:character, :inactive) }

      before do
        sign_in_as character

        get :index
      end

      it { is_expected.to redirect_to(characters_url) }
    end

    context "with an invalid character ID" do
      before do
        sign_in

        session[:character_id] = 0

        get :index
      end

      it { is_expected.to redirect_to(characters_url) }
    end

    context "when signed out" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(new_sessions_url) }
    end
  end
end
