# frozen_string_literal: true

module Clock
  class Base
    # Return the clock service interval as an integer.
    #
    # @return [Integer]
    def interval
      self.class.const_get(:INTERVAL).to_i
    end

    # Return the clock service name.
    #
    # @return [String]
    def name
      self.class.const_get(:NAME)
    end
  end
end
