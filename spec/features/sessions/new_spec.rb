# frozen_string_literal: true

require "rails_helper"

describe "Creating a new session", type: :feature do
  let(:account)  { create(:account, password: password) }
  let(:password) { generate(:password) }

  before do
    visit root_path
    click_link t("pages.index.sign_in")
  end

  it "successfully" do
    fill_in_and_submit(
      email:    account.email,
      password: password
    )

    expect(page).to have_text(t("characters.index.empty"))
  end

  it "with invalid e-mail" do
    fill_in_and_submit(
      email:    "example@localhost",
      password: password
    )

    expect(page).to have_text([
      SessionForm.human_attribute_name(:email).humanize,
      t("activemodel.errors.models.session_form.attributes.email.unknown")
    ].join(" "))
  end

  it "with invalid password" do
    fill_in_and_submit(
      email:    account.email,
      password: "invalid"
    )

    expect(page).to have_text([
      Account.human_attribute_name(:password).humanize,
      t("activemodel.errors.models.session_form.attributes.password.incorrect")
    ].join(" "))
  end

  protected

  def fill_in_and_submit(email:, password:)
    fill_in "E-mail Address", with: email
    fill_in "Password", with: password
    click_button t("sessions.new.submit")
  end
end
