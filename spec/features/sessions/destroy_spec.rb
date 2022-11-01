# frozen_string_literal: true

require "rails_helper"

describe "Destroying a session" do
  before do
    sign_in
  end

  it "successfully" do
    sign_out

    expect(page).not_to have_text(t("characters.index.empty"))
  end
end
