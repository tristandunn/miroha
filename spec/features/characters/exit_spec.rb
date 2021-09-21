# frozen_string_literal: true

require "rails_helper"

describe "Character exiting the game", type: :feature do
  let(:character) { create(:character) }

  before do
    sign_in_as_character character
  end

  it "successfully" do
    click_button "exit_game"

    expect(page).to have_css("h1", text: t("characters.index.header"))
  end
end
