# frozen_string_literal: true

require 'ruby2d/core'

require_relative 'assignment/dsl'
require_relative 'color'
require_relative 'properties'
require_relative 'shape'
require_relative 'transform'

# The ContextFree module
module ContextFree
  ##
  # The Canvas class renders the given grammar using Ruby2D.
  #
  # The window defaults to 640x640 pixels, and is resizable.
  # The following button inputs are supported:
  #
  # - Space bar pauses the updates
  # - +d+ toggles diagnostic output
  # - +s+ takes a screenshot
  # - Escape key closes the window
  class Canvas < Ruby2D::Window
    # Creates a new Canvas for the given grammar.
    # @param grammar [Grammar]
    # @param fps_limit [Integer]
    # @param steps_per_update [Integer]
    def initialize(grammar, fps_limit: 60, steps_per_update: 1)
      super(
        title: 'Ruby Context Free Art',
        width: 640,
        height: 640,
        fps_cap: fps_limit,
        vsync: true,
        )
      set resizable: true
      @steps_per_update = steps_per_update
      @running = true
      @grammar = grammar
      @bounds = nil
      @camera = nil
      @drawn_shapes = []
      @primitive_shapes = []
      @unevaluated_shapes = [@grammar.start_shape]
      set background: bg_color.to_rgba

      on :key_down do |event|
        button_down(event)
      end

      @draw_diagnostics = false
      @update_count = 0
      @update_counter = Ruby2D::Text.new("Update #{@update_count}")
    end

    ##
    # Updates the current state of the canvas.
    #
    # If running, this evaluates all unevaluated user-defined shapes, and adds the generated
    # primitive shapes to the list of primitive shapes, and creates a new list with
    # all of the new unevaluated shapes.
    def update
      return unless @running

      @steps_per_update.times do
        perform_update_step
      end
    end

    # Renders the current state of the canvas.
    def render
      update_bounds
      update_camera
      # Redraw already drawn shapes
      draw_shapes @drawn_shapes
      # Draw new primitive shapes
      draw_shapes @primitive_shapes
      @drawn_shapes.concat(@primitive_shapes)
      @primitive_shapes = []
      render_diagnostics
    end

    private

    def perform_update_step
      return if @unevaluated_shapes.empty?

      update_diagnostics

      new_unevaluated_shapes = []

      @unevaluated_shapes.each do |shape|
        primitive_shapes, user_defined_shapes = @grammar.eval_shape(shape)
        cull_small_shapes(primitive_shapes)
        cull_small_shapes(user_defined_shapes)
        @primitive_shapes.concat(primitive_shapes)
        new_unevaluated_shapes.concat(user_defined_shapes)
      end

      @unevaluated_shapes = new_unevaluated_shapes
    end

    def update_diagnostics
      @update_count += 1
      @update_counter.text = "Update #{@update_count}"
    end

    def render_diagnostics
      return unless @draw_diagnostics

      @update_counter.draw(x: 20, y: 20, color: 'yellow', rotate: 0)
    end

    def button_down(event)
      case event.key
      when 'space'
        @running = !@running
      when 'escape'
        close
      when 's'
        screenshot nil
      when 'd'
        @draw_diagnostics = !@draw_diagnostics
      end
    end

    def bg_color
      properties = Properties.new(Transform.identity, Color.white)
      properties.adjust!(@grammar.bg_color_adjustment) unless @grammar.bg_color_adjustment.nil?
      properties.color
    end

    def update_bounds
      return if @primitive_shapes.empty?

      bounds = Shape.bounds(@primitive_shapes)
      unless @bounds.nil?
        bounds[0][0] = [bounds[0][0], @bounds[0][0]].min
        bounds[0][1] = [bounds[0][1], @bounds[0][1]].min
        bounds[1][0] = [bounds[1][0], @bounds[1][0]].max
        bounds[1][1] = [bounds[1][1], @bounds[1][1]].max
      end
      @bounds = bounds
    end

    def update_camera
      if @bounds.nil?
        @camera = Transform.identity
        return
      end

      w = get(:width) * 1.0
      h = get(:height) * 1.0

      min_p, max_p = @bounds
      min_x, min_y = min_p
      max_x, max_y = max_p
      x_range = max_x - min_x
      y_range = max_y - min_y
      scale_x = w / x_range
      scale_y = h / y_range
      if scale_y > scale_x
        min_x -= x_range * 0.2
        max_x += x_range * 0.2
        x_range = max_x - min_x
        y_range = x_range
        middle_y = (min_y + max_y) / 2.0
        min_y = middle_y - y_range / 2.0
      else
        min_y -= y_range * 0.2
        max_y += y_range * 0.2
        y_range = max_y - min_y
        x_range = y_range
        middle_x = (min_x + max_x) / 2.0
        min_x = middle_x - x_range / 2.0
      end
      scale_x = w / x_range
      scale_y = h / y_range

      s = scale_x < scale_y ? scale_x : scale_y

      @camera = Transform
                .translate_y(h)
                .scale_y(-1)
                .translate_x(-min_x * s)
                .translate_y(-min_y * s)
                .scale(s)
    end

    def draw_shapes(shapes)
      return if shapes.empty?

      shapes.each do |shape|
        draw_shape shape
      end
    end

    def draw_shape(shape)
      c = shape.properties.color
      t = shape.properties.transform
      if shape.name == :square
        draw_quad (@camera * t) * Shape.vertices(shape.name), c
      elsif shape.name == :triangle
        draw_triangle (@camera * t) * Shape.vertices(shape.name), c
      end
    end

    def draw_quad(vertices, color)
      Ruby2D::Quad.draw(
        x1: vertices[0][0],
        y1: vertices[0][1],
        x2: vertices[1][0],
        y2: vertices[1][1],
        x3: vertices[2][0],
        y3: vertices[2][1],
        x4: vertices[3][0],
        y4: vertices[3][1],
        color: [color.to_rgba] * 4
      )
    end

    def draw_triangle(vertices, color)
      Ruby2D::Triangle.draw(
        x1: vertices[0][0],
        y1: vertices[0][1],
        x2: vertices[1][0],
        y2: vertices[1][1],
        x3: vertices[2][0],
        y3: vertices[2][1],
        color: [color.to_rgba] * 3
      )
    end

    def cull_small_shapes(shapes)
      shapes.filter! do |shape|
        shape.properties.transform.scale_factor >= @grammar.min_size
      end
    end
  end
end
