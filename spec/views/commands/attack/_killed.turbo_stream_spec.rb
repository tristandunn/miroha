# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_killed.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/killed",
      formats: :turbo_stream,
      locals:  {
        character:   double,
        damage:      double,
        target_id:   target_id,
        target_name: double
      }
    )

    rendered
  end

  let(:target_id) { SecureRandom.random_number(1..999) }

  before do
    stub_template("commands/attack/_killed.html.erb" => "KILLED_TEMPLATE")
  end

  it "removes the target from the surrounding monsters element" do
    expect(html).to have_turbo_stream_element(
      action: "remove",
      target: "surrounding_monster_#{target_id}"
    )
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("KILLED_TEMPLATE")
  end
end
