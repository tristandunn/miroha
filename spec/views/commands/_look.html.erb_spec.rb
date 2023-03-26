# frozen_string_literal: true

require "rails_helper"

describe "commands/_look.html.erb" do
  subject(:html) do
    render partial: "commands/look", locals: { description: description }

    rendered
  end

  let(:description) { Faker::Lorem.sentence }

  it "renders the room description" do
    expect(html).to have_message_row("td:nth-child(2)", text: description)
  end
end
