# frozen_string_literal: true

require "rails_helper"

describe "commands/_direct.html.erb" do
  subject(:html) do
    render partial: "commands/direct", locals: {
      character: character,
      message:   message,
      target:    target
    }

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:message)   { Faker::Lorem.sentence }
  let(:target)    { build_stubbed(:character) }

  it "renders the character name" do
    expect(html).to have_command_row("td:nth-child(1)", text: character.name)
  end

  it "renders the message to the target" do
    expect(html).to have_command_row("td:nth-child(2)", text: "#{target.name}: #{message}")
  end
end
