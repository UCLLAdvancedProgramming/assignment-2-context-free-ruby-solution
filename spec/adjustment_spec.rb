# frozen_string_literal: true

require 'rspec'

require_relative '../src/adjustment'
require_relative '../src/color'
require_relative '../src/properties'
require_relative '../src/transform'

module ContextFree
  RSpec.describe Adjustment do
    it 'adjusts hue correctly' do
      properties = Properties.new(Transform.identity, Color.new(hue: 340, saturation: 1, brightness: 1))
      properties.adjust! described_class.new(hue: 30)
      expect(properties.color.hue).to eq(10)
    end

    it 'adjusts saturation correctly towards 1' do
      properties = Properties.new(Transform.identity, Color.new(hue: 0, saturation: 0.5, brightness: 1))
      properties.adjust! described_class.new(saturation: 0.5)
      expect(properties.color.saturation).to be_within(1e-16).of(0.75)
    end

    it 'adjusts saturation correctly towards 0' do
      properties = Properties.new(Transform.identity, Color.new(hue: 0, saturation: 0.5, brightness: 1))
      properties.adjust! described_class.new(saturation: -0.5)
      expect(properties.color.saturation).to be_within(1e-16).of(0.25)
    end
  end
end
