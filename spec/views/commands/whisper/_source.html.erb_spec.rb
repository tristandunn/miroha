# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_source.html.erb", type: :view do
  subject(:html) do
    render partial: "commands/whisper/source", locals: {
      character:   character,
      message:     message,
      target_name: target.name
    }

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }
  let(:target)    { build_stubbed(:character) }

  it "renders the message to the character" do
    expect(html).to have_command_row(
      "td",
      text: strip_tags(
        t("commands.whisper.source.message_html",
          message: message, name: character.name, target_name: target.name)
      )
    )
  end
end
