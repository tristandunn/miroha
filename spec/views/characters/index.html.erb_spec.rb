# frozen_string_literal: true

require "rails_helper"

describe "characters/index.html.erb" do
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
      expect(html).to have_no_css("p", text: t("characters.index.empty"))
    end

    it "does not link to the new character path" do
      expect(html).to have_no_css(%(a[href="#{new_character_path}"]),
                                  text: t("characters.index.new_character"))
    end
  end

  context "with a recent character" do
    let(:character) { create(:character) }

    before do
      assign :characters, [character]

      Rails.cache.write(Character::SELECTED_KEY % character.id, 1, expires_in: 5.minutes)
    end

    it "renders the character as unselectable" do
      expect(html).to have_css("div.cursor-not-allowed", text: character.name)
    end

    it "does not render a button for the character" do
      expect(html).to have_no_css(
        %(form[method="post"][action="#{select_character_path(character)}"] button)
      )
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
      expect(html).to have_no_css("#characters")
    end
  end

  context "with a flash warning message" do
    let(:message) { Faker::Lorem.sentence }

    before do
      flash.now[:warning] = message
    end

    it "renders the message" do
      expect(html).to have_css("p", text: message)
    end
  end
end
