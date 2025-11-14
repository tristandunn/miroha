# frozen_string_literal: true

require "rails_helper"

describe "WorldEditor", type: :request do
  describe "GET /world_editor" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get world_editor_url

        expect(response).to redirect_to(new_sessions_url)
      end
    end
  end
end
