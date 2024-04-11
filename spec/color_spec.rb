# frozen_string_literal: true

require 'rspec'

require_relative '../src/color'

module ContextFree
  RSpec.describe Color do
    it 'converts to RGBA color properly' do
      rgba_color = described_class.new(hue: 0, saturation: 1, brightness: 1).to_rgba
      expect(rgba_color).to eq([1.0, 0.0, 0.0, 1.0])
    end
  end
end
