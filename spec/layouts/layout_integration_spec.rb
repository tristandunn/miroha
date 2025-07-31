# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Layout Integration", type: :request do
  describe "AccountsController" do
    it "uses standalone layout for new action" do
      get new_account_path
      expect(response).to render_template(layout: "standalone")
    end
  end

  describe "SessionsController" do
    it "uses standalone layout for new action" do
      get new_sessions_path
      expect(response).to render_template(layout: "standalone")
    end
  end

  describe "PagesController" do
    it "uses standalone layout for index action" do
      get root_path
      expect(response).to render_template(layout: "standalone")
    end
  end

  # Note: CharactersController layout tests are covered in controller specs
  # since they require authentication
end