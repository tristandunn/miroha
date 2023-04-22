# frozen_string_literal: true

module Commands
  class AttackCommand < Base
    THROTTLE_LIMIT  = 1
    THROTTLE_PERIOD = 1

    # Attempt to attack a target.
    def call
      if valid?
        if damage.positive?
          attack_success
        else
          attack_failure
        end
      end
    end

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        damage:      damage,
        target:      target,
        target_name: target_name
      }
    end

    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    # The attack failed, so broadcast a miss.
    #
    # @return [void]
    def attack_failure
      broadcast_missed
    end

    # The attack was successful, so damage and either attack or kill
    # the target.
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

    # Attack the target by saving the damage, triggering an event, and
    # broadcasting a message.
    #
    # @return [void]
    def attack_target
      trigger_target_attacked
      broadcast_attack
    end

    # Broadcast the attack to the room.
    #
    # @return [void]
    def broadcast_attack
      Turbo::StreamsChannel.broadcast_append_later_to(
        character.room_gid,
        target:  "messages",
        partial: "commands/attack/attack/hit",
        locals:  {
          attacker_name: character.name,
          character:     character,
          target_name:   target.name
        }
      )
    end

    # Broadcast the target killed to the room.
    #
    # @return [void]
    def broadcast_killed
      Turbo::StreamsChannel.broadcast_render_later_to(
        character.room_gid,
        partial: "commands/attack/attack/killed",
        locals:  {
          attacker_name: character.name,
          character:     character,
          target_id:     target.id,
          target_name:   target.name
        }
      )
    end

    # Broadcast the attack missed to the room.
    #
    # @return [void]
    def broadcast_missed
      Turbo::StreamsChannel.broadcast_append_later_to(
        character.room_gid,
        target:  "messages",
        partial: "commands/attack/attack/missed",
        locals:  {
          attacker_name: character.name,
          character:     character,
          target_name:   target.name
        }
      )
    end

    # Broadcast a sidebar character replacement to the character.
    #
    # @return [void]
    def broadcast_sidebar_character
      Turbo::StreamsChannel.broadcast_replace_later_to(
        character,
        target:  :character,
        partial: "game/sidebar/character",
        locals:  { character: character }
      )
    end

    # Return the damage being dealt to the target.
    #
    # @return [Integer]
    def damage
      @damage ||= SecureRandom.random_number(0..1)
    end

    # Apply possible damage and save, unless the target is dead.
    #
    # @return [void]
    def damage_target
      target.current_health -= damage
      target.save! unless target_dead?
    end

    # Expire the target's spawn.
    #
    # @return [void]
    def expire_spawn
      Spawns::Expire.call(target.spawn)
    end

    # Kill the target by broadcasting a killed message, expiring the spawn,
    # rewarding experience and possibly a level, and updating the
    # character sidebar.
    #
    # @return [void]
    def kill_target
      broadcast_killed
      expire_spawn
      reward_experience_and_level
      broadcast_sidebar_character
    end

    # Reward the character experience for killing the target, and level the
    # character up when needed.
    #
    # @return [void]
    def reward_experience_and_level
      character.experience += target.experience

      if character.experience.remaining <= 0
        character.level += 1
      end

      character.save!
    end

    # Attempt to find the target by name.
    #
    # @return [Monster] If a monster is found.
    # @return [nil] If a monster is not found.
    def target
      @target ||= character.room.monsters.where("LOWER(NAME) = ?", target_name.downcase).first
    end

    # Determine if the target is dead or not.
    #
    # @return [Boolean]
    def target_dead?
      !target.current_health.positive?
    end

    # Return the name of the target.
    #
    # @return [String]
    def target_name
      input_without_command.split(" ", 2).first.to_s
    end

    # Notify the target being attacked.
    #
    # @return [void]
    def trigger_target_attacked
      target.trigger(:attacked, character: character, damage: damage)
    end

    # Determine if the command is valid based on the target.
    #
    # @return [Boolean]
    def valid?
      target.present?
    end
  end
end
