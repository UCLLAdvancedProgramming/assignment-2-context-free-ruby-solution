# frozen_string_literal: true

require_relative 'color'
require_relative 'transform'

module ContextFree
  SQUARE_VERTICES = [[-0.5, -0.5], [0.5, -0.5], [0.5, 0.5], [-0.5, 0.5]].freeze
  TRIANGLE_VERTICES = lambda do
    h = 0.5 / Math.cos(Math::PI / 6.0)
    hp = h
    hn = -h / 2.0
    [[0.0, hp], [-0.5, hn], [0.5, hn]]
  end.call.freeze

  ##
  # The Shape class represents a shape with a name and properties
  #
  # @!attribute [r] name
  #   @return [Symbol] the name of the shape (:triangle, :square, or user-defined)
  # @!attribute [r] properties
  #   @return [Properties] the properties applied to this shape
  class Shape
    class << self
      ##
      # Calculates the bounds +[[min_x, min_y], [max_x, max_y]]+ of the given shapes
      #
      # @param shapes [Array<Shape>]
      # @return [Array<Array<Float>>] a pair of points representing the +(min_x, min_y)+ and +(max_x, max_y)+ positions
      def bounds(shapes)
        all_vertices = shapes.lazy.flat_map do |shape|
          shape.properties.transform * vertices(shape.name)
        end
        xs = all_vertices.map { |v| v[0] }
        ys = all_vertices.map { |v| v[1] }
        min_x, max_x = xs.minmax
        min_y, max_y = ys.minmax
        [[min_x, min_y], [max_x, max_y]]
      end

      ##
      # Returns the vertices of the given primitive shape
      #
      # @param primitive_shape [Symbol] the name of the primitive shape (:square or :triangle)
      # @return [Array<Array<Float>>]
      def vertices(primitive_shape)
        case primitive_shape
        when :square
          SQUARE_VERTICES
        when :triangle
          TRIANGLE_VERTICES
        else
          []
        end
      end
    end

    attr_reader :name, :properties

    ##
    # Create a new primitive shape with the given name and properties
    #
    # @param name [Symbol] the name of the shape (:square, :triangle, or user-defined)
    # @param properties [Properties] the properties to apply to the shape
    def initialize(name, properties)
      @name = name
      @properties = properties
      freeze
    end

    def ==(other)
      other.is_a?(Shape) && name == other.name && properties == other.properties
    end
  end
end
