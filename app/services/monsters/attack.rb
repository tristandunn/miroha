# frozen_string_literal: true

module Monsters
  class Attack
    # Initialize an instance.
    #
    # @param [Monster] monster The monster performing the attack.
    # @return [void]
    def initialize(monster)
      @monster = monster
    end

    # Create and call an instance.
    #
    # @return [void]
    def self.call(monster)
      new(monster).call
    end

    # Attempt to attack a target character.
    #
    # @return [void]
    def call
      if valid?
        if damage.positive?
          attack_success
        else
          attack_failure
        end
      end
    end

    private

    attr_reader :monster

    # The attack failed, so broadcast a miss.
    #
    # @return [void]
    def attack_failure
      broadcast_missed_to_character
      broadcast_missed_to_room
    end

    # The attack was successful, so damage and either attack or kill
    # the target character.
    #
    # @return [void]
    def attack_success
      damage_target

      if target_dead?
        kill_target
      else
        attack_target
      end
    end

    # Broadcast messages of the attack and update the target character sidebar.
    #
    # @return [void]
    def attack_target
      broadcast_attack_to_character
      broadcast_attack_to_room
      broadcast_sidebar_character
    end

    # Broadcast the attack to the target character.
    #
    # @return [void]
    def broadcast_attack_to_character
      Turbo::StreamsChannel.broadcast_append_later_to(
        target,
        target:  "messages",
        partial: "monsters/attack/target/hit",
        locals:  {
          attacker_name: monster.name,
          damage:        damage
        }
      )
    end

    # Broadcast the attack to the room.
    #
    # @return [void]
    def broadcast_attack_to_room
      Turbo::StreamsChannel.broadcast_append_later_to(
        monster.room,
        target:  "messages",
        partial: "monsters/attack/hit",
        locals:  {
          attacker_name: monster.name,
          character:     target,
          target_name:   target.name
        }
      )
    end

    # Broadcast the reset to the target character.
    #
    # @return [void]
    def broadcast_character_reset
      Turbo::StreamsChannel.broadcast_render_later_to(
        target,
        partial: "characters/reset",
        locals:  {
          attacker_name: monster.name,
          character:     target,
          damage:        damage,
          room:          Room.default
        }
      )
    end

    # Broadcast the target character respawn to the respawn room.
    #
    # @return [void]
    def broadcast_character_respawn
      Turbo::StreamsChannel.broadcast_render_later_to(
        Room.default,
        partial: "characters/respawn",
        locals:  { character: target }
      )
    end

    # Broadcast the kill to the room.
    #
    # @return [void]
    def broadcast_killed
      Turbo::StreamsChannel.broadcast_render_later_to(
        monster.room,
        partial: "monsters/attack/kill",
        locals:  {
          attacker_name: monster.name,
          character:     target,
          target_name:   target.name
        }
      )
    end

    # Broadcast the attack missed to the target character.
    #
    # @return [void]
    def broadcast_missed_to_character
      Turbo::StreamsChannel.broadcast_append_later_to(
        target,
        target:  "messages",
        partial: "monsters/attack/target/missed",
        locals:  {
          attacker_name: monster.name
        }
      )
    end

    # Broadcast the attack missed to the room.
    #
    # @return [void]
    def broadcast_missed_to_room
      Turbo::StreamsChannel.broadcast_append_later_to(
        monster.room,
        target:  "messages",
        partial: "monsters/attack/missed",
        locals:  {
          attacker_name: monster.name,
          character:     target,
          target_name:   target.name
        }
      )
    end

    # Broadcast a sidebar character replacement to the target character.
    #
    # @return [void]
    def broadcast_sidebar_character
      Turbo::StreamsChannel.broadcast_replace_later_to(
        target,
        target:  :character,
        partial: "game/sidebar/character",
        locals:  { character: target }
      )
    end

    # Return the damage being dealt to the target character.
    #
    # @return [Integer]
    def damage
      @damage ||= SecureRandom.random_number(0..1)
    end

    # Apply possible damage and save, unless the target character is dead.
    #
    # @return [void]
    def damage_target
      target.current_health -= damage
      target.save! unless target_dead?
    end

    # Returns the IDs for the top hated characters of the monster.
    #
    # @return [Array]
    def hates
      @hates ||= Cache::SortedSet.new(EventHandlers::Monster::Hate::KEY % monster.id).top(5)
    end

    # Kill the target character by broadcasting a killed message, moving the
    # character, and updating the character's sidebar.
    #
    # @return [void]
    def kill_target
      broadcast_killed
      reset_character
      broadcast_character_reset
      broadcast_character_respawn
    end

    # Resets the target character after being killed.
    #
    # @return[void]
    def reset_character
      target.update(
        current_health: target.maximum_health,
        room:           Room.default
      )
    end

    # Return the most hated character in the same room, if present.
    #
    # @return [Character|nil]
    def target
      return if hates.empty?

      @target ||= Character
                  .where(id: hates, room_id: monster.room_id)
                  .index_by(&:id)
                  .values_at(*hates)
                  .first
    end

    # Determine if the target character is dead or not.
    #
    # @return [Boolean]
    def target_dead?
      !target.current_health.positive?
    end

    # Determine if the attack is valid based on the target character
    # being present.
    #
    # @return [Boolean]
    def valid?
      target.present?
    end
  end
end
