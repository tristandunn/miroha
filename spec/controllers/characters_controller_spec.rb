# frozen_string_literal: true

require "rails_helper"

describe CharactersController, type: :controller do
  it { is_expected.to be_a(ApplicationController) }

  describe "#index" do
    context "when signed in" do
      let(:account) { create(:account) }

      before do
        sign_in_as account

        get :index
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template(:index) }
    end

    context "when signed out" do
      before do
        get :index
      end

      it { is_expected.to redirect_to(root_url) }
    end
  end
end
