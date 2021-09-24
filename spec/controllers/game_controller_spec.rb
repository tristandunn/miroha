# frozen_string_literal: true

require "rails_helper"

describe GameController, type: :controller do
  describe "#index", type: :controller do
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

    context "with an invalid character ID" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(characters_url) }
    end
  end
end
