# frozen_string_literal: true

require "rails_helper"

describe PagesController do
  describe "#index" do
    before do
      get :index
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:index, layout: "standalone") }
  end
end
