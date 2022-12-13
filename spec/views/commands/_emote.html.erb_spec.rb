# frozen_string_literal: true

require "rails_helper"

describe "commands/_emote.html.erb" do
  subject(:html) do
    render partial: "commands/emote", locals: { message: message }

    rendered
  end

  let(:message) { Faker::Lorem.sentence }

  it "renders the message" do
    expect(html).to have_message_row("td[colspan=2]", text: message)
  end
end
