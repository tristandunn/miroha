# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_success.html.erb" do
  subject(:html) do
    render partial: "commands/whisper/success", locals: {
      character: character,
      message:   message
    }

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }

  it "renders the message to the target" do
    expect(html).to have_message_row(
      "td",
      text: strip_tags(
        t("commands.whisper.success.message_html", message: message, name: character.name)
      )
    )
  end
end
