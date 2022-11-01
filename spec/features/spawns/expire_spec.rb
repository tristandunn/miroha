# frozen_string_literal: true

require "rails_helper"

describe "Expire spawns", clock: true, js: true do
  let(:character) { create(:character) }
  let(:room)      { character.room }

  before do
    sign_in_as_character character
  end

  it "expires the spawn" do
    spawn        = create(:spawn, :monster, room: room, expires_at: Time.current)
    monster_name = spawn.entity.name

    run("Expire spawns.")
    visit current_path

    expect(page).not_to have_text(monster_name)
  end
end
