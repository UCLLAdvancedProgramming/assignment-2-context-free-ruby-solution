# frozen_string_literal: true

require_relative '../rng'

module ContextFree
  ##
  # The Grammar class represents a grammar that can be evaluated to create a drawing
  #
  # @!attribute start_shape
  #   @return [Shape] the start shape of the grammar
  # @!attribute bg_color_adjustment
  #   @return [Adjustment] the adjustment that should be applied to the background color
  # @!attribute min_size
  #   @return [Float] the minimum shape size, any shape smaller than this will be culled
  # @!attribute rng
  #   @return [RNG] the random number generator to be used when random rules are selected
  class Grammar
    attr_accessor :start_shape, :bg_color_adjustment, :min_size, :rng

    # Create a new grammar
    def initialize
      @rng = RNG.new
      @start_shape = nil
      @bg_color_adjustment = nil
      @min_size = 0.01
    end

    ##
    # Evaluates the given Shape.
    #
    # This randomly picks one of the shape's rules and evaluates it,
    # yielding new primitive shapes that can be drawn to the Canvas
    # and new user-defined shapes that will be evaluated in the next
    # update.
    #
    # @param shape [Shape] the shape to evaluate
    # @return [Array<Array<Shape>>] an array containing two arrays of shapes.
    #   The first array should contain all new primitive shapes.
    #   The second array should contain all new user-defined shapes.
    def eval_shape(shape)
      [[], []]
    end
  end
end
