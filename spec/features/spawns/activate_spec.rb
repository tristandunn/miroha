# frozen_string_literal: true

require "rails_helper"

describe "Activate spawns", :clock, :js do
  let(:character) { create(:character) }
  let(:room)      { character.room }

  before do
    sign_in_as_character character
  end

  it "broadcasts spawn to the room" do
    spawn = create(:spawn, :monster, room: room, entity: nil, activates_at: Time.current)

    run("Activate spawns.")

    expect(page).to have_text(spawn.reload.entity.name)
  end
end
