# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_killed.turbo_stream.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/killed",
      formats: :turbo_stream,
      locals:  {
        damage:      double,
        room:        double,
        target_name: double
      }
    )

    rendered
  end

  let(:target_id) { SecureRandom.random_number(1..999) }

  before do
    stub_template("commands/attack/_killed.html.erb" => "KILLED_TEMPLATE")
    stub_template("game/_surroundings.html.erb" => "SURROUNDINGS_TEMPLATE")
  end

  it "appends to the messages element" do
    expect(html).to have_turbo_stream_element(
      action: "append",
      target: "messages"
    )
  end

  it "replaces to the surroundings element" do
    expect(html).to have_turbo_stream_element(
      action: "replace",
      target: "surroundings"
    )
  end

  it "renders the HTML template" do
    expect(html).to include("KILLED_TEMPLATE")
  end

  it "renders the surroundings HTML template" do
    expect(html).to include("SURROUNDINGS_TEMPLATE")
  end
end
