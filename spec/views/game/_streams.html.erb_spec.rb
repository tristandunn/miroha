# frozen_string_literal: true

require "rails_helper"

describe "game/_streams.html.erb" do
  subject(:html) do
    render partial: "game/streams",
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "attaches the streams controller" do
    expect(html).to have_css(%([data-controller=streams] #streams))
  end

  it "renders the character stream with a target" do
    expect(html).to have_stream(id: dom_id(character), attributes: "[data-streams-target=stream]")
  end

  it "renders the chat stream" do
    expect(html).to have_stream(id: dom_id(character.room))
  end

  it "renders the streams controller notice" do
    expect(html).to have_css("[data-streams-target=notice] span", text: t("game.streams.title")).and(
      have_css("[data-streams-target=notice] span", text: t("game.streams.message"))
    )
  end

  protected

  def have_stream(id:, attributes: nil)
    have_css(
      <<~SELECTOR.strip
        #streams
        turbo-cable-stream-source[channel="Turbo::StreamsChannel"][id="#{id}"]#{attributes}
      SELECTOR
    )
  end
end
