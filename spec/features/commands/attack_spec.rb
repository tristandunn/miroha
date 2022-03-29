# frozen_string_literal: true

require "rails_helper"

describe "Sending the attack command", type: :feature, js: true do
  let(:character) { create(:character, room: spawn.room) }
  let(:monster)   { create(:monster, room: room) }
  let(:room)      { create(:room) }
  let(:spawn)     { monster.spawn }

  before do
    sign_in_as_character character
  end

  it "displays the attacker hit message to the sender" do
    send_command(:attack, monster.name)

    expect(page).to have_attacker_hit_message(monster, damage: 1)
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

    wait_for(have_attacker_hit_message(monster, damage: 1)) do
      using_session(:nearby_character) do
        expect(page).not_to have_attacker_hit_message(monster, damage: 1)
      end
    end
  end

  it "does not broadcast the attacker hit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:attack, monster.name)

    wait_for(have_attacker_hit_message(monster, damage: 1)) do
      using_session(:distant_character) do
        expect(page).not_to have_attacker_hit_message(monster, damage: 1)
      end
    end
  end

  it "does not broadcast the attack hit message to other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:attack, monster.name)

    wait_for(have_attacker_hit_message(monster, damage: 1)) do
      using_session(:distant_character) do
        expect(page).not_to have_attack_hit_message(monster)
      end
    end
  end

  context "when the monster is killed" do
    let(:monster) { create(:monster, room: room, current_health: 0) }

    it "displays the attacker killed message to the sender" do
      send_command(:attack, monster.name)

      expect(page).to have_attacker_killed_message(monster, damage: 1)
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

      wait_for(have_attacker_killed_message(monster, damage: 1)) do
        using_session(:nearby_character) do
          expect(page).not_to have_attacker_killed_message(monster, damage: 1)
        end
      end
    end

    it "does not broadcast the attacker killed message to other rooms" do
      using_session(:distant_character) do
        sign_in_as_character create(:character)
      end

      send_command(:attack, monster.name)

      wait_for(have_attacker_killed_message(monster, damage: 1)) do
        using_session(:distant_character) do
          expect(page).not_to have_attacker_killed_message(monster, damage: 1)
        end
      end
    end

    it "does not broadcast the attack killed message to other rooms" do
      using_session(:distant_character) do
        sign_in_as_character create(:character)
      end

      send_command(:attack, monster.name)

      wait_for(have_attacker_killed_message(monster, damage: 1)) do
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

  context "with an unknown name" do
    it "displays unknown name message to the sender" do
      send_command(:attack, :fake)

      expect(page).to have_attacker_unknown_message("fake")
    end

    it "does not broadcast the unknown name message to the room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:attack, :fake)

      wait_for(have_attacker_unknown_message("fake")) do
        using_session(:nearby_character) do
          expect(page).not_to have_attacker_unknown_message("fake")
        end
      end
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

  def have_attacker_hit_message(monster, damage:)
    have_css(
      "#messages .message-attacker-hit",
      text: t("commands.attack.attacker.hit.message", target_name: monster.name, count: damage)
    )
  end

  def have_attacker_killed_message(monster, damage:)
    have_css(
      "#messages .message-attacker-killed",
      text: t("commands.attack.attacker.killed.message", target_name: monster.name, count: damage)
    )
  end

  def have_attacker_unknown_message(name)
    have_css(
      "#messages .message-attacker-unknown",
      text: t("commands.attack.attacker.unknown.message", target_name: name)
    )
  end
end
