# frozen_string_literal: true

require "rails_helper"

describe "Health" do
  describe "GET /health" do
    it "returns success" do
      get "/health"

      expect(response).to have_http_status(:ok)
    end

    context "with no database connection" do
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(ActiveRecord::ConnectionAdapters::SQLite3Adapter)
          .to receive(:execute).and_raise
        # rubocop:enable RSpec/AnyInstance
      end

      it "returns service unavailable" do
        get "/health"

        expect(response).to have_http_status(:service_unavailable)
      end
    end

    context "with pending migrations" do
      before do
        allow(ActiveRecord::Migration).to receive(:check_all_pending!).and_raise
      end

      it "returns service unavailable" do
        get "/health"

        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end
end
