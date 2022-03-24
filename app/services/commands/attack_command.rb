# frozen_string_literal: true

module Commands
  class AttackCommand < Base
    # Broadcast a whisper command to the target.
    def call
      if valid?
        damage_target
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

    # Broadcast the attack to the room.
    #
    # @return [void]
    def broadcast_attack
      Turbo::StreamsChannel.broadcast_append_later_to(
        character.room,
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
        character.room,
        partial: "commands/attack/attack/killed",
        locals:  {
          attacker_name: character.name,
          character:     character,
          target_id:     target.id,
          target_name:   target.name
        }
      )
    end

    # Return the damage being dealt to the target.
    #
    # @return [Integer]
    def damage
      1
    end

    # Apply damage to the target.
    #
    # @return [void]
    def damage_target
      target.current_health -= damage
      target.save!

      if target.current_health.positive?
        broadcast_attack
      else
        broadcast_killed
        expire_spawn
      end
    end

    # Expire the target's spawn.
    #
    # @return [void]
    def expire_spawn
      Spawns::Expire.call(target.spawn)
    end

    # Attempt to find the target by name.
    #
    # @return [Monster] If a monster is found.
    # @return [nil] If a monster is not found.
    def target
      return @target if defined?(@target)

      @target = character.room.monsters.where("LOWER(NAME) = ?", target_name.downcase).first
    end

    # Return the name of the target.
    #
    # @return [String]
    def target_name
      input_without_command.split(" ", 2).first.to_s
    end

    # Determine if the command is valid based on the target.
    #
    # @return [Boolean]
    def valid?
      target.present?
    end
  end
end
