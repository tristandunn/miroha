# frozen_string_literal: true

require "rails_helper"

describe "game/_streams.html.erb", type: :view do
  subject(:html) do
    render partial: "game/streams",
           locals:  { character: character }

    rendered
  end

  let(:character) { build_stubbed(:character) }

  it "renders the character stream" do
    expect(html).to have_stream(id: dom_id(character))
  end

  it "renders the chat stream" do
    expect(html).to have_stream(id: dom_id(character.room))
  end

  protected

  def have_stream(id:)
    have_css(
      <<~SELECTOR.strip
        #streams
        turbo-cable-stream-source[channel="Turbo::StreamsChannel"][id="#{id}"]
      SELECTOR
    )
  end
end
