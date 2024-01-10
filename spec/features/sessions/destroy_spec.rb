# frozen_string_literal: true

require "rails_helper"

describe "Destroying a session" do
  before do
    sign_in
    visit characters_path
  end

  it "successfully" do
    sign_out

    expect(page).to have_no_text(t("characters.index.empty"))
  end
end
