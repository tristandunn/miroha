# frozen_string_literal: true

require "rails_helper"

describe "Creating a new character" do
  before do
    create(:room, :default)
    create_account
  end

  it "successfully" do
    name = generate(:name)

    fill_in_character_and_submit(name: name)

    expect(page).to have_css("#sidebar h1", text: name)
  end

  it "with an invalid name" do
    character = create(:character)

    fill_in_character_and_submit(name: character.name)

    expect(page).to have_text([
      Character.human_attribute_name(:name).humanize,
      t("errors.messages.taken")
    ].join(" "))
  end

  it "with an invalid password" do
    fill_in_character_and_submit(name: "T")

    expect(page).to have_text([
      Character.human_attribute_name(:name).humanize,
      t("errors.messages.too_short", count: Character::MINIMUM_NAME_LENGTH)
    ].join(" "))
  end

  protected

  def create_account
    visit root_path
    click_on t("pages.index.new_account")
    fill_in t("activemodel.attributes.account_form.email"),
            with: generate(:email)
    fill_in t("activemodel.attributes.account_form.password"),
            with: generate(:password)
    click_on t("accounts.new.submit")
  end

  def fill_in_character_and_submit(name:)
    fill_in t("activemodel.attributes.character_form.name"), with: name
    click_on t("characters.new.submit")
  end
end
