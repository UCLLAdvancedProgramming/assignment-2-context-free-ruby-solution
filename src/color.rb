# frozen_string_literal: true

module ContextFree
  ##
  # The Color class represents a color in HSV (or HSB) form, with alpha:
  #
  # - hue
  # - saturation
  # - brightness
  # - alpha (0 for completely transparent i.e. invisible, 1 for opaque)
  #
  # @see https://en.wikipedia.org/wiki/HSL_and_HSV
  #
  # @!attribute [r] hue
  #   @return [Float] the hue in "degrees" in the range +[0, 360)+
  # @!attribute [r] saturation
  #   @return [Float] the saturation from 0 to 1
  # @!attribute [r] brightness
  #   @return [Float] the brightness value from 0 to 1 (this is the V in HSV, or the B in HSB)
  # @!attribute [r] alpha
  #   @return [Float] the alpha value from 0 to 1 (0 is completely transparent (invisible), 1 is opaque)
  class Color
    class << self
      # Returns black
      # @return [Color]
      def black
        Color.new hue: 0, saturation: 0, brightness: 0, alpha: 1
      end

      # Returns white
      # @return [Color]
      def white
        Color.new hue: 0, saturation: 0, brightness: 1, alpha: 1
      end

      # Returns red
      # @return [Color]
      def red
        Color.new hue: 0, saturation: 1, brightness: 1, alpha: 1
      end

      # Returns orange
      # @return [Color]
      def orange
        Color.new hue: 30, saturation: 1, brightness: 1, alpha: 1
      end

      # Returns yellow
      # @return [Color]
      def yellow
        Color.new hue: 60, saturation: 1, brightness: 1, alpha: 1
      end

      # Returns green
      # @return [Color]
      def green
        Color.new hue: 120, saturation: 1, brightness: 1, alpha: 1
      end

      # Returns cyan
      # @return [Color]
      def cyan
        Color.new hue: 180, saturation: 1, brightness: 1, alpha: 1
      end

      # Returns blue
      # @return [Color]
      def blue
        Color.new hue: 240, saturation: 1, brightness: 1, alpha: 1
      end

      # Returns magenta
      # @return [Color]
      def magenta
        Color.new hue: 300, saturation: 1, brightness: 1, alpha: 1
      end

      ##
      # Applies the given adjustment (-1 to 1) to the given base value (0 to 1)
      #
      # - an +adjustment+ of 0 returns +base+, unchanged
      # - a negative adjustment moves the base value closer to 0,
      #   e.g. starting at 0.8 with an adjustment of -0.5 takes away 50% of 0.8,
      #   resulting in 0.4.
      # - a positive adjustment moves the base value closer to 1,
      #   e.g. starting at 0.8 with an adjustment of 0.5 adds 50% of 0.2 (this is 1 - 0.8),
      #   resulting in 0.9
      #
      # @param base [Float] the base value (0 to 1)
      # @param adjustment [Float] the adjustment value (-1 to 1)
      # @return [Float] the adjusted value
      def adjust(base, adjustment)
        if adjustment.zero?
          base
        elsif adjustment.negative?
          base + base * adjustment
        else
          base + (1 - base) * adjustment
        end
      end
    end

    attr_reader :hue, :saturation, :brightness, :alpha

    ##
    # Creates a new color with given hue, saturation, brightness and alpha
    #
    # @param hue [Float, Integer] the hue in the range +[0, 360)+
    # @param saturation [Float, Integer] the saturation from 0 to 1
    # @param brightness [Float, Integer] the brightness from 0 to 1
    # @param alpha [Float, Integer] the alpha value from 0 to 1
    def initialize(hue:, saturation:, brightness:, alpha: 1.0)
      @hue = hue % 360.0
      @saturation = saturation.to_f.clamp(0.0, 1.0)
      @brightness = brightness.to_f.clamp(0.0, 1.0)
      @alpha = alpha.to_f.clamp(0.0, 1.0)
      freeze
    end

    ##
    # Add the given value to the hue, returning a new color.
    #
    # The resulting hue is the current hue plus the given value mod 360.0.
    #
    # @param h [Float, Integer] the value to add
    # @return [Color]
    def add_hue(h)
      new_hue = (@hue + h.to_f) % 360.0
      Color.new(hue: new_hue, saturation: saturation, brightness: brightness, alpha: alpha)
    end

    ##
    # Adjust the saturation value, returning a new color.
    #
    # @see Color::adjust
    #
    # @param sat [Float, Integer] the adjustment from -1 to 1 (negative moves it closer to 0, positive moves it closer to 1)
    # @return [Color]
    def add_saturation(sat)
      sat = sat.to_f.clamp(-1.0, 1.0)
      new_sat = Color.adjust saturation, sat
      Color.new(hue: hue, saturation: new_sat, brightness: brightness, alpha: alpha)
    end

    ##
    # Adjust the brightness value, returning a new color.
    #
    # @see Color::adjust
    #
    # @param b [Float, Integer] the adjustment from -1 to 1 (negative moves it closer to 0, positive moves it closer to 1)
    # @return [Color]
    def add_brightness(b)
      b = b.to_f.clamp(-1.0, 1.0)
      new_b = Color.adjust brightness, b
      Color.new(hue: hue, saturation: saturation, brightness: new_b, alpha: alpha)
    end

    ##
    # Adjust the alpha value, returning a new color.
    #
    # @see Color::adjust
    #
    # @param alpha [Float, Integer] the adjustment from -1 to 1 (negative moves it closer to 0, positive moves it closer to 1)
    # @return [Color]
    def add_alpha(alpha)
      alpha = alpha.to_f.clamp(-1.0, 1.0)
      new_alpha = Color.adjust self.alpha, alpha
      Color.new(hue: hue, saturation: saturation, brightness: brightness, alpha: new_alpha)
    end

    ##
    # Converts the color to RGBA (with R, G, B, and A from 0 to 1)
    #
    # @return [Array<Float>] the color in RGBA format
    def to_rgba
      chroma = brightness * saturation
      hue_prime = hue / 60.0
      x = chroma * (1.0 - (hue_prime % 2.0 - 1.0).abs)
      r1, g1, b1 =
        if 0 <= hue_prime && hue_prime < 1
          [chroma, x, 0.0]
        elsif 1 <= hue_prime && hue_prime < 2
          [x, chroma, 0.0]
        elsif 2 <= hue_prime && hue_prime < 3
          [0.0, chroma, x]
        elsif 3 <= hue_prime && hue_prime < 4
          [0.0, x, chroma]
        elsif 4 <= hue_prime && hue_prime < 5
          [x, 0.0, chroma]
        else
          [chroma, 0.0, x]
        end
      m = brightness - chroma
      [r1 + m, g1 + m, b1 + m, @alpha]
    end

    def ==(other)
      other.is_a?(Color) && @hue == other.hue && @saturation == other.saturation && @brightness == other.brightness && @alpha == other.alpha
    end
  end
end
