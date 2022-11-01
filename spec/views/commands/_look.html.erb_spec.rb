# frozen_string_literal: true

require "rails_helper"

describe "commands/_look.html.erb" do
  subject(:html) do
    render partial: "commands/look", locals: { room: room }

    rendered
  end

  let(:room) { build_stubbed(:room) }

  it "renders the room description" do
    expect(html).to have_command_row("td:nth-child(2)", text: room.description)
  end
end
