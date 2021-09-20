# frozen_string_literal: true

require "rails_helper"

describe "Selecting a character", type: :feature do
  let(:character) { create(:character) }

  it "successfully" do
    sign_in_as character.account
    click_button character.name

    expect(page).to have_css("#sidebar h1", text: character.name)
  end
end
