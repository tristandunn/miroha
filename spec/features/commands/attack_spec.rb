# frozen_string_literal: true

require "rails_helper"

describe "Sending the attack command", :js do
  let(:character) { create(:character, room: room) }
  let(:damage)    { 1 }
  let(:monster)   { spawn.entity }
  let(:room)      { spawn.room }
  let(:spawn)     { create(:spawn, :monster) }

  before do
    sign_in_as_character character

    allow(SecureRandom).to receive(:random_number).with(0..1).and_return(damage)
  end

  it "displays the attacker hit message to the sender" do
    send_command(:attack, monster.name)

    expect(page).to have_attacker_hit_message(monster, damage: damage)
  end

  it "broadcasts the attack hit message to the room" do
    create(:room, x: 0, y: 1, z: 0)

    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:attack, monster.name)

    using_session(:nearby_character) do
      expect(page).to have_attack_hit_message(monster)
    end
  end

  it "does not broadcast the attacker hit message to room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:attack, monster.name)

    wait_for(have_attacker_hit_message(monster, damage: damage)) do
      using_session(:nearby_character) do
        expect(page).not_to have_attacker_hit_message(monster, damage: damage)
      end
    end
  end

  it "does not broadcast the attacker hit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:attack, monster.name)

    wait_for(have_attacker_hit_message(monster, damage: damage)) do
      using_session(:distant_character) do
        expect(page).not_to have_attacker_hit_message(monster, damage: damage)
      end
    end
  end

  it "does not broadcast the attack hit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:attack, monster.name)

    wait_for(have_attacker_hit_message(monster, damage: damage)) do
      using_session(:distant_character) do
        expect(page).not_to have_attack_hit_message(monster)
      end
    end
  end

  context "when the monster is missed" do
    let(:damage) { 0 }

    it "displays the attacker missed message to the sender" do
      send_command(:attack, monster.name)

      expect(page).to have_attacker_missed_message(monster)
    end

    it "broadcasts the attack missed message to the room" do
      create(:room, x: 0, y: 1, z: 0)

      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack, monster.name)

      using_session(:nearby_character) do
        expect(page).to have_attack_missed_message(monster)
      end
    end
  end

  context "when the monster is killed" do
    before do
      monster.update!(current_health: damage)
    end

    it "displays the attacker killed message to the sender" do
      send_command(:attack, monster.name)

      expect(page).to have_attacker_killed_message(monster, damage: damage)
    end

    it "broadcasts new experience to the character" do
      send_command(:attack, monster.name)

      expect(page).to have_css(
        "#experience",
        text: "#{monster.experience} / #{character.experience.needed}"
      )
    end

    it "broadcasts the attack killed message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack, monster.name)

      using_session(:nearby_character) do
        expect(page).to have_attack_killed_message(monster)
      end
    end

    it "removes the monster from the surroundings for the sender" do
      send_command(:attack, monster.name)

      expect(page).not_to have_surrounding_monster(monster)
    end

    it "removes the monster from the surroundings for the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack, monster.name)

      using_session(:nearby_character) do
        expect(page).not_to have_surrounding_monster(monster)
      end
    end

    it "does not broadcast the attacker killed message to room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack, monster.name)

      wait_for(have_attacker_killed_message(monster, damage: damage)) do
        using_session(:nearby_character) do
          expect(page).not_to have_attacker_killed_message(monster, damage: damage)
        end
      end
    end

    it "does not broadcast the attacker killed message to other rooms" do
      using_session(:distant_character) do
        sign_in_as_character create(:character)
      end

      send_command(:attack, monster.name)

      wait_for(have_attacker_killed_message(monster, damage: damage)) do
        using_session(:distant_character) do
          expect(page).not_to have_attacker_killed_message(monster, damage: damage)
        end
      end
    end

    it "does not broadcast the attack killed message to other rooms" do
      using_session(:distant_character) do
        sign_in_as_character create(:character)
      end

      send_command(:attack, monster.name)

      wait_for(have_attacker_killed_message(monster, damage: damage)) do
        using_session(:distant_character) do
          expect(page).not_to have_attack_killed_message(monster)
        end
      end
    end

    context "when the character levels up" do
      let(:character) { create(:character, room: spawn.room, experience: 999) }

      it "broadcasts new level to the character" do
        send_command(:attack, monster.name)

        expect(page).to have_css(
          "#character h2",
          text: t("game.sidebar.character.level", level: 2)
        )
      end
    end
  end

  context "with an invalid target name" do
    it "displays invalid name message to the sender" do
      send_command(:attack, :fake)

      expect(page).to have_attacker_invalid_message("fake")
    end

    it "does not broadcast the invalid name message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack, :fake)

      wait_for(have_attacker_invalid_message("fake")) do
        using_session(:nearby_character) do
          expect(page).not_to have_attacker_invalid_message("fake")
        end
      end
    end
  end

  context "with no target name" do
    it "displays unknown name message to the sender" do
      send_command(:attack)

      expect(page).to have_attacker_missing_message
    end

    it "does not broadcast the unknown name message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack)

      wait_for(have_attacker_missing_message) do
        using_session(:nearby_character) do
          expect(page).not_to have_attacker_missing_message
        end
      end
    end

    it "uses the last target when available" do
      send_command(:attack, monster.name)

      wait_for(have_css("#messages .message-attacker-hit")) do
        send_command(:attack)

        expect(page).to have_css("#messages .message-attacker-hit", count: 2)
      end
    end
  end

  context "when using the /a alias" do
    it "displays the message to the sender" do
      send_command(:a, monster.name)

      expect(page).to have_attacker_hit_message(monster, damage: damage)
    end
  end

  protected

  def have_attack_hit_message(monster)
    have_css(
      "#messages .message-attack-hit",
      text: t("commands.attack.attack.hit.message",
              attacker_name: character.name,
              target_name:   monster.name)
    )
  end

  def have_attack_killed_message(monster)
    have_css(
      "#messages .message-attack-killed",
      text: t("commands.attack.attack.killed.message",
              attacker_name: character.name,
              target_name:   monster.name)
    )
  end

  def have_attack_missed_message(monster)
    have_css(
      "#messages .message-attack-missed",
      text: t("commands.attack.attack.missed.message",
              attacker_name: character.name,
              target_name:   monster.name)
    )
  end

  def have_attacker_hit_message(monster, damage:)
    have_css(
      "#messages .message-attacker-hit",
      text: t("commands.attack.attacker.hit.message", target_name: monster.name, count: damage)
    )
  end

  def have_attacker_invalid_message(name)
    have_css(
      "#messages .message-attacker-unknown",
      text: t("commands.attack.attacker.unknown.invalid", target_name: name)
    )
  end

  def have_attacker_killed_message(monster, damage:)
    have_css(
      "#messages .message-attacker-killed",
      text: t("commands.attack.attacker.killed.message", target_name: monster.name, count: damage)
    )
  end

  def have_attacker_missed_message(monster)
    have_css(
      "#messages .message-attacker-missed",
      text: t("commands.attack.attacker.missed.message", target_name: monster.name)
    )
  end

  def have_attacker_missing_message
    have_css(
      "#messages .message-attacker-unknown",
      text: t("commands.attack.attacker.unknown.missing")
    )
  end
end
