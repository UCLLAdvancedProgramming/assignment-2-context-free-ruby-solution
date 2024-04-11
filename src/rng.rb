# frozen_string_literal: true

module ContextFree
  # A random number generator
  class RNG
    # Create a new random number generator with the given seed
    # @param seed [Integer | nil] the seed
    def initialize(seed = nil)
      @prng = if seed
                Random.new seed
              else
                Random.new
              end
    end

    # Generate a random floating point number between 0 and 1
    # @return [Float]
    def next
      @prng.rand
    end
  end
end
