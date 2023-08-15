# frozen_string_literal: true

require "rails_helper"

describe "commands/say/_success.html.erb" do
  subject(:html) do
    render partial: "commands/say/success", locals: {
      character: character,
      message:   message
    }

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }

  it "renders the character name" do
    expect(html).to have_message_row("td:nth-child(1)", text: character.name)
  end

  it "renders the message" do
    expect(html).to have_message_row("td:nth-child(2)", text: message)
  end
end
