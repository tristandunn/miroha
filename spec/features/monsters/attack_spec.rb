# frozen_string_literal: true

require "rails_helper"

describe "Monsters attack", :clock, :js do
  let(:character) { create(:character, room: room) }
  let(:damage)    { 1 }
  let(:monster)   { spawn.entity }
  let(:room)      { spawn.room }
  let(:spawn)     { create(:spawn, :monster) }

  before do
    sign_in_as_character character

    hates = Redis::SortedSet.new(EventHandlers::Monster::Hate::KEY % monster.id)
    hates.incr(character.id, 2)

    allow(SecureRandom).to receive(:random_number).with(0..1).and_return(damage)
  end

  it "displays the monster target hit message to the character" do
    run("Monsters attack characters.")

    expect(page).to have_monster_hit_target_message
  end

  it "broadcasts the new hit points to the damaged character" do
    maximum_health  = character.health.maximum
    expected_health = maximum_health - damage

    run("Monsters attack characters.")

    expect(page).to have_css(%(#character div[title="#{expected_health} / #{maximum_health}"]))
  end

  it "broadcasts the monster hit message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    run("Monsters attack characters.")

    using_session(:nearby_character) do
      expect(page).to have_monster_hit_message
    end
  end

  it "does not broadcast the monster target hit message to the room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    run("Monsters attack characters.")

    using_session(:nearby_character) do
      expect(page).not_to have_monster_hit_target_message
    end
  end

  it "does not broadcast the monster hit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    run("Monsters attack characters.")

    wait_for(have_monster_hit_target_message) do
      using_session(:distant_character) do
        expect(page).not_to have_monster_hit_message
      end
    end
  end

  context "when the target is missed" do
    let(:damage) { 0 }

    it "displays the monster missed message to the sender" do
      run("Monsters attack characters.")

      expect(page).to have_monster_target_missed_message
    end

    it "broadcasts the monster missed message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      run("Monsters attack characters.")

      using_session(:nearby_character) do
        expect(page).to have_monster_missed_message
      end
    end

    it "does not broadcast the monster target missed message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      run("Monsters attack characters.")

      using_session(:nearby_character) do
        expect(page).not_to have_monster_target_missed_message
      end
    end

    it "does not broadcast the monster missed message to other rooms" do
      using_session(:distant_character) do
        sign_in_as_character create(:character)
      end

      run("Monsters attack characters.")

      wait_for(have_monster_target_missed_message) do
        using_session(:distant_character) do
          expect(page).not_to have_monster_missed_message
        end
      end
    end
  end

  context "when the target is killed" do
    let(:damage) { character.current_health }

    before do
      create(:room, :default)
    end

    it "displays the monster target killed message to the sender" do
      run("Monsters attack characters.")

      expect(page).to have_monster_target_killed_message
    end

    it "broadcasts the monster killed target message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      run("Monsters attack characters.")

      using_session(:nearby_character) do
        expect(page).to have_monster_killed_target_message
      end
    end

    it "removes the target from the surroundings" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      run("Monsters attack characters.")

      using_session(:nearby_character) do
        expect(page).not_to have_surrounding_character(character)
      end
    end

    it "broadcasts the character respawn message to the respawn room" do
      using_session(:character_in_spawn_room) do
        sign_in_as_character create(:character, room: Room.default)
      end

      run("Monsters attack characters.")

      wait_for(have_monster_target_killed_message) do
        using_session(:character_in_spawn_room) do
          expect(page).to have_character_respawn_message(name: character.name)
        end
      end
    end

    it "adds the character to the surroundings in the target room" do
      using_session(:distant_character) do
        sign_in_as_character create(:character, room: Room.default)
      end

      run("Monsters attack characters.")

      using_session(:distant_character) do
        expect(page).to have_surrounding_character(character)
      end
    end

    it "does not broadcast the monster killed target message to other rooms" do
      using_session(:distant_character) do
        sign_in_as_character create(:character)
      end

      run("Monsters attack characters.")

      wait_for(have_monster_target_killed_message) do
        using_session(:distant_character) do
          expect(page).not_to have_monster_killed_target_message
        end
      end
    end
  end

  protected

  def have_character_respawn_message(name:)
    have_css(
      "#messages .message-character-respawn",
      text: t("characters.respawn.message", name: name)
    )
  end

  def have_monster_hit_target_message
    have_css(
      "#messages .message-monsters-attack-target-hit",
      text: t("monsters.attack.target.hit.message", attacker_name: monster.name, count: damage)
    )
  end

  def have_monster_hit_message
    have_css(
      "#messages .message-monsters-attack-hit",
      text: t("monsters.attack.hit.message",
              attacker_name: monster.name,
              target_name:   character.name)
    )
  end

  def have_monster_killed_target_message
    have_css(
      "#messages .message-monsters-attack-kill",
      text: t("monsters.attack.kill.message",
              attacker_name: monster.name,
              target_name:   character.name)
    )
  end

  def have_monster_missed_message
    have_css(
      "#messages .message-monsters-attack-missed",
      text: t("monsters.attack.missed.message",
              attacker_name: monster.name,
              target_name:   character.name)
    )
  end

  def have_monster_target_killed_message
    have_css(
      "#messages .message-monsters-attack-target-killed",
      text: t("monsters.attack.target.kill.message", attacker_name: monster.name, count: damage)
    )
  end

  def have_monster_target_missed_message
    have_css(
      "#messages .message-monsters-attack-target-missed",
      text: t("monsters.attack.target.missed.message", attacker_name: monster.name)
    )
  end
end
