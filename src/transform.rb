# frozen_string_literal: true

require 'matrix'

module ContextFree
  ##
  # The Transform class represents a 2D transformation
  #
  # It supports:
  #
  # - translation (moving)
  # - scaling
  # - rotation
  #
  # @!attribute [r] matrix
  #   @return [Matrix] the 3x3 matrix that represents the 2D transformation
  class Transform
    attr_reader :matrix

    class << self
      # Creates an identity transform
      # @return [Transform]
      def identity
        Transform.new Matrix.identity(3)
      end

      ##
      # Creates a translation (move) by +x+
      #
      # @param x [Float, Integer]
      # @return [Transform]
      def translate_x(x)
        Transform.new Matrix[[1, 0, x], [0, 1, 0], [0, 0, 1]]
      end

      ##
      # Creates a translation (move) by +y+
      #
      # @param y [Float, Integer]
      # @return [Transform]
      def translate_y(y)
        Transform.new Matrix[[1, 0, 0], [0, 1, y], [0, 0, 1]]
      end

      ##
      # Creates a uniform scaling transform by factor +s+
      #
      # @param s [Float, Integer]
      # @return [Transform]
      def scale(s)
        Transform.new Matrix[[s, 0, 0], [0, s, 0], [0, 0, 1]]
      end

      ##
      # Creates a scaling transform in the X direction by factor +x+
      #
      # @param x [Float, Integer]
      # @return [Transform]
      def scale_x(x)
        Transform.new Matrix[[x, 0, 0], [0, 1, 0], [0, 0, 1]]
      end

      ##
      # Creates a scaling transform in the Y direction by factor +y+
      #
      # @param y [Float, Integer]
      # @return [Transform]
      def scale_y(y)
        Transform.new Matrix[[1, 0, 0], [0, y, 0], [0, 0, 1]]
      end

      ##
      # Creates a rotation transform by +degrees+ number of degrees
      #
      # @param degrees [Float, Integer] the rotation in degrees, counter-clockwise
      # @return [Transform]
      def rotate(degrees)
        radians = -degrees * Math::PI / 180.0
        cos = Math.cos(radians)
        sin = Math.sin(radians)
        Transform.new Matrix[[cos, sin, 0], [-sin, cos, 0], [0, 0, 1]]
      end
    end

    ##
    # Creates a new transform from the given 3x3 matrix
    #
    # @param matrix [Matrix]
    def initialize(matrix)
      @matrix = matrix
      freeze
    end

    ##
    # Returns a new transform that is the current transform with an X translation
    #
    # @param x [Float, Integer]
    # @return [Transform]
    def translate_x(x)
      Transform.new(@matrix * (Transform.translate_x x).matrix)
    end

    ##
    # Returns a new transform that is the current transform with a Y translation
    #
    # @param y [Float, Integer]
    # @return [Transform]
    def translate_y(y)
      Transform.new(@matrix * (Transform.translate_y y).matrix)
    end

    ##
    # Returns a new transform that is the current transform with a rotation by +degrees+
    #
    # @param degrees [Float, Integer] the rotation in degrees, counter-clockwise
    # @return [Transform]
    def rotate(degrees)
      Transform.new(@matrix * (Transform.rotate degrees).matrix)
    end

    ##
    # Returns a new transform that is the current transform with a uniform scale
    #
    # @param s [Float, Integer] the scaling factor
    # @return [Transform]
    def scale(s)
      Transform.new(@matrix * (Transform.scale s).matrix)
    end

    ##
    # Returns a new transform that is the current transform with a scale in the X direction
    #
    # @param x [Float, Integer]
    # @return [Transform]
    def scale_x(x)
      Transform.new(@matrix * (Transform.scale_x x).matrix)
    end

    ##
    # Returns a new transform that is the current transform with a scale in the Y direction
    #
    # @param y [Float, Integer]
    # @return [Transform]
    def scale_y(y)
      Transform.new(@matrix * (Transform.scale_y y).matrix)
    end

    ##
    # Returns a measure for the scaling factor of this transformation
    #
    # This is used to cull shapes if they are too small.
    #
    # @return [Float]
    def scale_factor
      d = @matrix.determinant
      Math.sqrt(d.abs)
    end

    ##
    # Applies this transform to either:
    #
    # - a transform
    # - an array of vertices
    # - a single vertex
    #
    # @param other [Transform, Array<Float>, Array<Array<Float>>]
    # @return [Transform, Array<Float>, Array<Array<Float>>]
    def *(other)
      case other
      in Transform => transform
        apply_transform(transform)
      in [Float, Float] => vertex
        apply_vertex(vertex)
      in Array => vertices
        apply_vertices(vertices)
      end
    end

    def ==(other)
      other.is_a?(Transform) && @matrix == other.matrix
    end

    private

    def apply_transform(transform)
      Transform.new(@matrix * transform.matrix)
    end

    def apply_vertices(vertices)
      vertices.map do |vertex|
        apply_vertex(vertex)
      end
    end

    def apply_vertex(vertex)
      v = Vector[*vertex, 1]
      (@matrix * v)[0..1]
    end
  end
end
