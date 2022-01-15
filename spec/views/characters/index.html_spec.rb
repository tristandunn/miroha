# frozen_string_literal: true

require "rails_helper"

describe "characters/index.html.erb", type: :view do
  subject(:html) do
    render template: "characters/index"

    rendered
  end

  before do
    assign :characters, []
  end

  it "renders the header" do
    expect(html).to have_css("h1", text: t("characters.index.header"))
  end

  it "renders a sign out button" do
    expect(html).to have_css(
      %(form[action="#{sessions_path}"][method="post"] button[type="submit"])
    )
  end

  context "with characters" do
    let(:characters) { create_list(:character, 2) }

    before do
      assign :characters, characters
    end

    it "renders a button for each character" do
      characters.each do |character|
        expect(html).to have_css(
          %(form[method="post"][action="#{select_character_path(character)}"] button),
          text: character.name
        )
      end
    end

    it "does not render the empty message" do
      expect(html).not_to have_css("p", text: t("characters.index.empty"))
    end

    it "does not link to the new character path" do
      expect(html).not_to have_css(%(a[href="#{new_character_path}"]),
                                   text: t("characters.index.new_character"))
    end
  end

  context "without characters" do
    it "renders the empty message" do
      expect(html).to have_css("p", text: t("characters.index.empty"))
    end

    it "links to the new character path" do
      expect(html).to have_css(%(a[href="#{new_character_path}"]),
                               text: t("characters.index.new_character"))
    end

    it "does not render the character list" do
      expect(html).not_to have_css("#characters")
    end
  end
end
