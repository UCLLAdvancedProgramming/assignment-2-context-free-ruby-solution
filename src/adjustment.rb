# frozen_string_literal: true

require_relative 'color'
require_relative 'shape'
require_relative 'transform'

module ContextFree
  ##
  # The Adjustment class represents an shape adjustment
  #
  # @!attribute [r] x
  #   @return [Float, nil] the X translation
  # @!attribute [r] y
  #   @return [Float, nil] the Y translation
  # @!attribute [r] rotate
  #   @return [Float, nil] the rotation in degrees (counter-clockwise)
  # @!attribute [r] size
  #   @return [Array<Size>, nil] the scaling (in X direction and Y direction)
  # @!attribute [r] hue
  #   @return [Float, nil] the hue to add (in degrees)
  # @!attribute [r] saturation
  #   @return [Float, nil] the saturation to add (-1 to 1)
  # @!attribute [r] brightness
  #   @return [Float, nil] the brightness to add (-1 to 1)
  # @!attribute [r] alpha
  #   @return [Float, nil] the alpha (transparency) to add (-1 to 1)
  class Adjustment
    attr_reader :x, :y, :rotate, :size, :hue, :saturation, :brightness, :alpha

    ##
    # Creates a new Adjustment object
    #
    # @param x [Float, Integer, nil] the X translation
    # @param y [Float, Integer, nil] the Y translation
    # @param rotate [Float, Integer, nil] the rotation in degrees (counter-clockwise)
    # @param size [Float, Array<Float>, nil] the scaling (either as a single float (uniform), or a pair of floats (non-uniform))
    # @param hue [Float, Integer, nil] the hue to add (in degrees)
    # @param saturation [Float, Integer, nil] the saturation to add (-1 to 1)
    # @param brightness [Float, Integer, nil] the brightness to add (-1 to 1)
    # @param alpha [Float, Integer, nil] the alpha (transparency) to add (-1 to 1)
    def initialize(
      x: nil,
      y: nil,
      rotate: nil,
      size: nil,
      hue: nil,
      saturation: nil,
      brightness: nil,
      alpha: nil
    )
      @x = x&.to_f
      @y = y&.to_f
      @rotate = rotate&.to_f
      case size
      in nil
        @size = nil
      in Numeric => s
        @size = [s.to_f, s.to_f].freeze
      in Array => ar
        @size = ar.map(&:to_f).freeze
      end
      @hue = hue&.to_f
      @saturation = saturation&.to_f
      @brightness = brightness&.to_f
      @alpha = alpha&.to_f
      freeze
    end
  end
end
