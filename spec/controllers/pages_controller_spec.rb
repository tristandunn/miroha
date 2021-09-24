# frozen_string_literal: true

require "rails_helper"

describe PagesController, type: :controller do
  describe "#index", type: :controller do
    before do
      get :index
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:index) }
  end
end
