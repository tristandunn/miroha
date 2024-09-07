# frozen_string_literal: true

module Cache
  class SortedSet
    # Initialize a new cached sorted set.
    #
    # @param [String] key The key for the sorted set.
    # @param [Integer] expires_in A relative expiration time, in seconds.
    # @return [void]
    def initialize(key, expires_in: nil)
      @expires_in = expires_in
      @key        = key
    end

    # Increment the rank of a member in the sorted set.
    #
    # @param [String|Integer] member The member identifier.
    # @param [Integer] amount The amount to increase the member's rank.
    # @return [void]
    def increment(member, amount)
      values = fetch
      values[member] ||= 0
      values[member]  += amount

      write(values)
    end

    # Return the top members in the sorted set.
    #
    # @param [Integer] count The number of members to return.
    # @return [Array] The
    def top(count)
      fetch.sort_by { |_, value| -value }.first(count).map(&:first)
    end

    private

    attr_reader :expires_in, :key

    # Fetch the value of the sorted set.
    #
    # @return [Hash] The new or existing sorted set.
    def fetch
      Rails.cache.fetch(key, expires_in: expires_in) { {} }
    end

    # Write a new value to the sorted set.
    #
    # @return [void]
    def write(value)
      Rails.cache.write(key, value, expires_in: expires_in)
    end
  end
end
