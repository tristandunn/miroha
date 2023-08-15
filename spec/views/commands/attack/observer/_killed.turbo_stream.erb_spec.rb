# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/observer/_killed.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/observer/killed",
      formats: :turbo_stream,
      locals:  {
        character:   character,
        damage:      damage,
        target_id:   target.id,
        target_name: target.name
      }
    )

    rendered
  end

  let(:character) { build_stubbed(:character) }
  let(:damage)    { rand(1..10) }
  let(:target)    { build_stubbed(:monster) }

  before do
    stub_template("commands/attack/observer/_killed.html.erb" => "KILLED_TEMPLATE")
  end

  it "removes the target from the surrounding monsters element" do
    expect(html).to have_turbo_stream_element(
      action: "remove",
      target: "surrounding_monster_#{target.id}"
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
