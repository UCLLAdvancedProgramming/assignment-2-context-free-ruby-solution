# frozen_string_literal: true

require 'rspec'

require_relative '../src/adjustment'
require_relative '../src/assignment/dsl'
require_relative '../src/assignment/grammar'
require_relative '../src/properties'
require_relative '../src/shape'

module ContextFree
  class MockRNG < RNG
    attr_accessor :next

    def initialize(next_value)
      super()
      @next = next_value
    end
  end

  RSpec.describe Grammar do
    context 'when basic' do
      before do
        DSL.reset
        load 'samples/basic.rb', DSL
      end

      it 'evaluates to three squares and a triangle' do
        primitive_shapes, user_defined_shapes = DSL.grammar.eval_shape(Shape.new(:shapes, Properties.default))
        expect(primitive_shapes).to eq([
                                         Shape.new(:square, Properties.default),
                                         Shape.new(:square, Properties.default.adjust(Adjustment.new(x: 0.5, y: 0.5, size: [0.5, 0.5], hue: 30, saturation: 1, brightness: 1))),
                                         Shape.new(:square, Properties.default.adjust(Adjustment.new(x: 1, y: 1, hue: 90, saturation: 1, brightness: 1, rotate: 10))),
                                         Shape.new(:triangle, Properties.default.adjust(Adjustment.new(hue: 240, saturation: 1, brightness: 1)))
                                       ])
        expect(user_defined_shapes).to eq([])
      end
    end

    context 'when doubled' do
      before do
        DSL.reset
        load 'samples/doubled.rb', DSL
      end

      it 'evaluates shapes to a square and a triangle' do
        primitive_shapes, user_defined_shapes = DSL.grammar.eval_shape(Shape.new(:shapes, Properties.default))
        expect(primitive_shapes).to eq([
                                         Shape.new(:square, Properties.default.adjust(Adjustment.new(hue: 0, saturation: 1, brightness: 1))),
                                         Shape.new(:triangle, Properties.default.adjust(Adjustment.new(x: 2, hue: 240, saturation: 1, brightness: 1)))
                                       ])
        expect(user_defined_shapes).to eq([])
      end

      it 'evaluates shapes with a y shift properly' do
        primitive_shapes, user_defined_shapes = DSL.grammar.eval_shape(Shape.new(:shapes, Properties.default.adjust(Adjustment.new(y: 2))))
        expect(primitive_shapes).to eq([
                                         Shape.new(:square, Properties.default.adjust(Adjustment.new(y: 2, hue: 0, saturation: 1, brightness: 1))),
                                         Shape.new(:triangle, Properties.default.adjust(Adjustment.new(y: 2, x: 2, hue: 240, saturation: 1, brightness: 1)))
                                       ])
        expect(user_defined_shapes).to eq([])
      end

      it 'evaluates doubled to two shapes' do
        primitive_shapes, user_defined_shapes = DSL.grammar.eval_shape(Shape.new(:doubled, Properties.default))
        expect(primitive_shapes).to eq([])
        expect(user_defined_shapes).to eq([
                                            Shape.new(:shapes, Properties.default),
                                            Shape.new(:shapes, Properties.default.adjust(Adjustment.new(y: 2)))
                                          ])
      end
    end

    context 'when rect' do
      before do
        DSL.reset
        load 'samples/rect.rb', DSL
      end

      it 'has the current start shape' do
        expect(DSL.grammar.start_shape).to eq(Shape.new(:square, Properties.default.adjust(Adjustment.new(size: [2, 1]))))
      end
    end

    context 'when red or black' do
      before do
        DSL.reset
        load 'samples/red_or_black.rb', DSL
      end

      it 'selects a red square 25% of the time' do
        DSL.grammar.rng = MockRNG.new(0.1)
        primitive_shapes, user_defined_shapes = DSL.grammar.eval_shape(Shape.new(:red_or_black, Properties.default))
        expect(primitive_shapes).to eq([Shape.new(:square, Properties.default.adjust(Adjustment.new(hue: 0, brightness: 1, saturation: 1)))])
        expect(user_defined_shapes).to eq([])
      end

      it 'selects a black square 75% of the time' do
        DSL.grammar.rng = MockRNG.new(0.3)
        primitive_shapes, user_defined_shapes = DSL.grammar.eval_shape(Shape.new(:red_or_black, Properties.default))
        expect(primitive_shapes).to eq([Shape.new(:square, Properties.default)])
        expect(user_defined_shapes).to eq([])
      end
    end
  end
end
