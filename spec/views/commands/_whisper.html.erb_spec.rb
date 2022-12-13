# frozen_string_literal: true

require "rails_helper"

describe "commands/_whisper.html.erb" do
  subject(:html) do
    render partial: "commands/whisper", locals: {
      character: character,
      message:   message,
      target:    target
    }

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }
  let(:target)    { build_stubbed(:character) }

  it "renders the message to the target" do
    expect(html).to have_message_row(
      "td",
      text: strip_tags(
        t("commands.whisper.target.message_html", message: message, name: character.name)
      )
    )
  end
end
