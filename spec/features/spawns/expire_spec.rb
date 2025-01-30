# frozen_string_literal: true

require "rails_helper"

describe "Expire spawns", :js do
  let(:character) { create(:character) }
  let(:room)      { character.room }

  before do
    sign_in_as_character character
  end

  it "expires the spawn" do
    spawn = create(:spawn, :monster, room: room, expires_at: Time.current)

    run_job
    visit current_path

    expect(page).to have_css("#surroundings").and(
      have_no_css("#surrounding_monster_#{spawn.entity_id}")
    )
  end

  protected

  def run_job
    Clock::ExpireSpawnsJob.new.perform
  end
end
