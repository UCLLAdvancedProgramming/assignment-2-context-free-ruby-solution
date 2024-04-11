# frozen_string_literal: true

module ContextFree
  ##
  # The Properties class describes the properties of a shape
  #
  # @!attribute transform
  #   @return [Transform] the transformation to apply to the shape
  # @!attribute color
  #   @return [Color] the color of the shape
  class Properties
    class << self
      # Creates default properties (identity transform and black color)
      # @return [Properties]
      def default
        Properties.new Transform.identity, Color.black
      end
    end

    attr_accessor :transform, :color

    ##
    # Creates a new Properties object with given transform and color
    #
    # @param transform [Transform]
    # @param color [Color]
    def initialize(transform, color)
      @transform = transform
      @color = color
    end

    ##
    # Applies the given adjustment to these properties, returning new properties.
    #
    # The current properties remain unchanged.
    #
    # @param adjustment [Adjustment]
    # @return [Properties]
    def adjust(adjustment)
      result = clone
      result.adjust!(adjustment)
      result
    end

    ##
    # Applies the given adjustment to these properties, changing these properties.
    #
    # @param adjustment [Adjustment]
    def adjust!(adjustment)
      adjust_transform!(adjustment)
      adjust_color!(adjustment)
    end

    def ==(other)
      other.is_a?(Properties) && @transform == other.transform && @color == other.color
    end

    private

    def adjust_transform!(adjustment)
      @transform = @transform.translate_x(adjustment.x) unless adjustment.x.nil?
      @transform = @transform.translate_y(adjustment.y) unless adjustment.y.nil?
      @transform = @transform.rotate(adjustment.rotate) unless adjustment.rotate.nil?
      @transform = @transform.scale_x(adjustment.size[0]).scale_y(adjustment.size[1]) unless adjustment.size.nil?
    end

    def adjust_color!(adjustment)
      @color = @color.add_hue(adjustment.hue) unless adjustment.hue.nil?
      @color = @color.add_saturation(adjustment.saturation) unless adjustment.saturation.nil?
      @color = @color.add_brightness(adjustment.brightness) unless adjustment.brightness.nil?
      @color = @color.add_alpha(adjustment.alpha) unless adjustment.alpha.nil?
    end
  end
end
