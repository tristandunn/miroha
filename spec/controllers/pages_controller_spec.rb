# frozen_string_literal: true

require "rails_helper"

describe PagesController, type: :controller do
  describe "#index", type: :controller do
    context "without a current character" do
      before do
        get :index
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:index) }
    end

    context "with a current character" do
      let(:character) { create(:character) }

      before do
        sign_in_as character

        get :index
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template("game/index", layout: "game") }
    end
  end
end
