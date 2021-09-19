# frozen_string_literal: true

require "rails_helper"

describe "characters/new.html.erb", type: :view do
  subject(:html) do
    render

    rendered
  end

  let(:form) { CharacterForm.new }

  before do
    assign :form, form
  end

  it "renders a form to create a character" do
    expect(html).to have_css(
      %(form.highlight-errors[action="#{characters_path}"][method="post"])
    )
  end

  it "renders an name field" do
    expect(html).to have_css(
      %(input#character_form_name[autocomplete=false][autofocus][required])
    )
  end

  it "renders a submit button" do
    expect(html).to have_css(
      %(button[type="submit"]),
      text: t("characters.new.submit")
    )
  end

  context "with errors" do
    before do
      form.errors.add(:name, :invalid)
    end

    it "wraps name field in error container" do
      expect(html).to have_css(".field_with_errors #character_form_name")
    end

    it "displays name error message" do
      expect(html).to have_css("p", text: [
        CharacterForm.human_attribute_name(:name).humanize,
        t("errors.messages.invalid")
      ].join(" "))
    end
  end
end
