# frozen_string_literal: true

require "rails_helper"

describe "commands/emote/_success.html.erb" do
  subject(:html) do
    render partial: "commands/emote/success",
           locals:  {
             character:   character,
             message:     message,
             punctuation: punctuation
           }

    rendered
  end

  let(:character)   { build_stubbed(:character) }
  let(:message)     { Faker::Lorem.sentence }
  let(:punctuation) { "!" }

  it "renders the message" do
    expect(html).to have_message_row(
      "td[colspan=2]",
      text: "#{character.name} #{message}#{punctuation}"
    )
  end
end
