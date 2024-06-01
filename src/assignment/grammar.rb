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
  # @!attribute [r] shapes
  #   @return [Hash<Symbol, Array<Array(Float | Integer, Proc)>>] a hash from shape name (as a symbol) to an array of all rules, expressed as a pair of a weight and a proc
  class Grammar
    attr_accessor :start_shape, :bg_color_adjustment, :min_size, :rng
    attr_reader :shapes

    # Create a new grammar
    def initialize
      @rng = RNG.new
      @start_shape = nil
      @bg_color_adjustment = nil
      @min_size = 0.01
      @shapes = {}
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
      if shape.name == :square || shape.name == :triangle
        # Primitive shapes just evaluate to themselves
        [[shape], []]
      else
        # Choose a rule
        rule = pick_rule(shape.name)
        # Create the rule evaluation context
        rule_context = DSL::RuleContext.new(grammar: self, properties: shape.properties)
        # Evaluate the rule within the rule evaluation context
        rule_context.instance_eval(&rule)
        # Get the primitive shapes and user defined shapes out of our context
        [rule_context.primitive_shapes, rule_context.user_defined_shapes]
      end
    end

    private

    # Randomly choose a rule for a shape with the given name
    # Returns a Proc
    def pick_rule(shape_name)
      rules = @shapes[shape_name]
      # If there's only one rule, we can return that
      return rules[0][1] if rules.size == 1

      total = rules.sum(&:first)
      selection = @rng.next * total
      running_total = 0
      rules.each do |rule|
        weight, block = rule
        running_total += weight
        return block if running_total > selection
      end
      rules.last[1]
    end
  end
end
