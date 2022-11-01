# frozen_string_literal: true

require "rails_helper"

describe "characters/_reset.turbo_stream.erb" do
  subject(:html) do
    render partial: "characters/reset",
           formats: :turbo_stream,
           locals:  {
             attacker_name: attacker_name,
             character:     character,
             damage:        damage,
             room:          room
           }

    rendered
  end

  let(:attacker_name) { generate(:name) }
  let(:character)     { build_stubbed(:character) }
  let(:damage)        { rand(1..10) }
  let(:room)          { build_stubbed(:room) }

  before do
    stub_template("commands/_look.turbo_stream.erb" => "LOOK_TEMPLATE")
    stub_template("commands/move/_surroundings.turbo_stream.erb" => "SURROUNDINGS_TEMPLATE")
  end

  it "appends a kill message to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "updates the character element" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "character"
    )
  end

  it "renders the look HTML template" do
    expect(html).to include("LOOK_TEMPLATE")
  end

  it "renders the surroundings HTML template" do
    expect(html).to include("SURROUNDINGS_TEMPLATE")
  end
end
