# frozen_string_literal: true

require "rails_helper"

describe "monsters/attack/_kill.turbo_stream.erb" do
  subject(:html) do
    render partial: "monsters/attack/kill",
           formats: :turbo_stream,
           locals:  {
             attacker_name: attacker_name,
             character:     character,
             target_name:   character.name
           }

    rendered
  end

  let(:attacker_name) { generate(:name) }
  let(:character)     { build_stubbed(:character) }

  before do
    stub_template("monsters/attack/_kill.html.erb" => "KILL_TEMPLATE")
  end

  it "removes the target from the surroundings" do
    expect(html).to have_turbo_stream_element(
      action: "remove",
      target: "surrounding_character_#{character.id}"
    )
  end

  it "appends a kill message to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "renders the kill HTML template" do
    expect(html).to include("KILL_TEMPLATE")
  end
end
