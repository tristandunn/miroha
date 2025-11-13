# frozen_string_literal: true

require "rails_helper"

describe "commands/use/observer/_success.html.erb" do
  subject(:html) do
    render(
      partial: "commands/use/observer/success",
      locals:  {
        character: character,
        name:      name
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:name)      { generate(:name) }

  it "renders the observer success message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: t(
        "commands.use.observer.success.message",
        character_name: character.name,
        name:           name
      )
    )
  end

  it "includes the character ID on the message row" do
    expect(html).to have_css(%(tr[data-character-id="#{character.id}"]))
  end
end
