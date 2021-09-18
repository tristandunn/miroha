# frozen_string_literal: true

require "rails_helper"

describe "Viewing the index page", type: :feature do
  it "successfully" do
    visit root_path

    expect(page).to have_css("h1", text: t("title"))
  end
end
