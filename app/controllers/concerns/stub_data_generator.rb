# frozen_string_literal: true

# :nocov:
require "faker"

##
# StubDataGenerator provides mock data generation for testing and development purposes.
# This module generates fake data objects that mimic real application entities like
# characters, rooms, accounts, and various game elements.
#
# The module uses a combination of specific stub generators for known parameter types
# and fallback generation for unrecognized parameters. It leverages the Faker gem
# for realistic fake data where appropriate.
#
# @example Basic usage
#   StubDataGenerator.generate_stub_data("character")
#   # => Character struct with random attributes
#
# @example Fallback generation
#   StubDataGenerator.generate_stub_data("unknown_param")
#   # => "stub_unknown_param"
module StubDataGenerator
  extend self

  ##
  # Struct representing a user account with aliases
  # @!attribute [rw] aliases
  #   @return [Hash] mapping of short aliases to full command names
  Account   = Struct.new(:aliases, keyword_init: true)

  ##
  # Struct representing a game character
  # @!attribute [rw] name
  #   @return [String] the character's name
  # @!attribute [rw] id
  #   @return [Integer] unique character identifier
  # @!attribute [rw] level
  #   @return [Integer] character's experience level
  # @!attribute [rw] current_health
  #   @return [Integer] character's current health points
  # @!attribute [rw] maximum_health
  #   @return [Integer] character's maximum health points
  # @!attribute [rw] account
  #   @return [Account] associated user account
  Character = Struct.new(:name, :id, :level, :current_health, :maximum_health, :account, keyword_init: true)

  ##
  # Struct representing a game room/location
  # @!attribute [rw] description
  #   @return [String] textual description of the room
  # @!attribute [rw] id
  #   @return [Integer] unique room identifier
  Room      = Struct.new(:description, :id, keyword_init: true)

  ##
  # Struct representing a target entity (NPCs, monsters, etc.)
  # @!attribute [rw] name
  #   @return [String] the target's name
  # @!attribute [rw] id
  #   @return [Integer] unique target identifier
  Target    = Struct.new(:name, :id, keyword_init: true)

  ##
  # Generates appropriate stub data based on the parameter name.
  #
  # This method first checks if the parameter has a specific stub generator
  # defined in SPECIFIC_STUBS. If not, it falls back to pattern-based
  # generation using generate_fallback_data.
  #
  # @param param_name [String] the name of the parameter to generate data for
  # @return [Object] generated stub data of appropriate type
  #
  # @example Generate character data
  #   generate_stub_data("character")
  #   # => Character struct with random attributes
  #
  # @example Generate message data
  #   generate_stub_data("message")
  #   # => "Lorem ipsum dolor sit amet..."
  def generate_stub_data(param_name)
    return generate_specific_stub(param_name) if specific_stub_type?(param_name)

    generate_fallback_data(param_name)
  end

  ##
  # Hash mapping parameter names to their specific stub generators.
  # Each value is a proc that returns the appropriate stub data.
  #
  # Supported parameter types:
  # - character: Full Character struct with stats and account
  # - message: Random sentence using Faker
  # - damage: Random integer between 1-20
  # - target_name/source_name: Random monster name
  # - target/source: Target struct with name and id
  # - room: Room struct with description and id
  # - direction: Cardinal/vertical direction
  # - aliases: Hash of command aliases
  # - commands: Array of command documentation
  # - account: Account struct with aliases
  SPECIFIC_STUBS = {
    "character"   => -> { character_stub },
    "message"     => -> { Faker::Lorem.sentence },
    "damage"      => -> { rand(1..20) },
    "target_name" => -> { %w(goblin orc troll skeleton dragon).sample },
    "source_name" => -> { %w(goblin orc troll skeleton dragon).sample },
    "target"      => -> { target_stub },
    "source"      => -> { target_stub },
    "room"        => -> { room_stub },
    "direction"   => -> { %w(north south east west up down).sample },
    "aliases"     => -> { sample_aliases },
    "commands"    => -> { sample_commands },
    "account"     => -> { account_stub }
  }.freeze

  private

  ##
  # Checks if the given parameter name has a specific stub generator defined.
  #
  # @param param_name [String] parameter name to check
  # @return [Boolean] true if specific stub exists, false otherwise
  def specific_stub_type?(param_name)
    SPECIFIC_STUBS.key?(param_name)
  end

  ##
  # Generates stub data using a specific generator for the parameter.
  #
  # @param param_name [String] parameter name with known stub generator
  # @return [Object] result of calling the specific stub generator
  def generate_specific_stub(param_name)
    SPECIFIC_STUBS[param_name].call
  end

  ##
  # Generates fallback stub data for unrecognized parameter names.
  # Uses pattern matching on the parameter name to infer appropriate data type.
  #
  # Patterns recognized:
  # - Contains "name": Returns sample character name
  # - Contains "count": Returns random integer 1-10
  # - Contains "aliases": Returns sample command aliases hash
  # - Contains "command": Returns "fake"
  # - Default: Returns "stub_#{param_name}"
  #
  # @param param_name [String] parameter name to generate fallback data for
  # @return [Object] generated fallback data
  def generate_fallback_data(param_name)
    return sample_names if param_name.include?("name")
    return rand(1..10) if param_name.include?("count")
    return sample_aliases if param_name.include?("aliases")
    return "fake" if param_name.include?("command")

    "stub_#{param_name}"
  end

  ##
  # Returns a random sample character name from a predefined list.
  #
  # @return [String] randomly selected character name
  def sample_names
    %w(Alice Bob Charlie Diana Eve).sample
  end

  ##
  # Returns a sample hash of command aliases mapping short keys to full commands.
  #
  # @return [Hash<String, String>] mapping of aliases to commands
  def sample_aliases
    { "k" => "attack", "l" => "look", "s" => "say" }
  end

  ##
  # Creates a Character struct populated with random fantasy-themed data.
  # The character includes full stats, a name from fantasy literature,
  # and an associated account with command aliases.
  #
  # @return [Character] fully populated character stub object
  def character_stub
    Character.new(
      name:           %w(Aragorn Legolas Gimli Boromir Frodo).sample,
      id:             rand(1..100),
      level:          rand(1..50),
      current_health: rand(50..100),
      maximum_health: 100,
      account:        Account.new(aliases: { "k" => "attack", "l" => "look" })
    )
  end

  ##
  # Creates a Target struct representing an NPC or monster.
  # Used for both target and source parameters in combat scenarios.
  #
  # @return [Target] target stub object with name and id
  def target_stub
    Target.new(
      name: %w(goblin orc troll skeleton dragon).sample,
      id:   rand(1..100)
    )
  end

  ##
  # Creates a Room struct representing a game location.
  # Includes a generic description and random ID.
  #
  # @return [Room] room stub object with description and id
  def room_stub
    Room.new(
      description: "A dimly lit chamber",
      id:          rand(1..50)
    )
  end

  ##
  # Creates an Account struct with sample command aliases.
  # Used for representing user account data in stub scenarios.
  #
  # @return [Account] account stub object with aliases
  def account_stub
    Account.new(aliases: { "k" => "attack", "l" => "look" })
  end

  ##
  # Creates a sample array of command documentation objects.
  # Each command includes name, arguments format, and description.
  #
  # @return [Array<Hash>] array of command documentation hashes
  def sample_commands
    [
      { name: "attack", arguments: "<target>", description: "Attack a target" },
      { name: "look", arguments: "[target]", description: "Look around" },
      { name: "say", arguments: "<message>", description: "Say something" }
    ]
  end
end
