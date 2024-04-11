# frozen_string_literal: true

require 'rspec'

require_relative '../src/transform'

module ContextFree
  RSpec.describe Transform do
    it 'translates by x' do
      t = described_class.translate_x 20
      pos = t * [0.0, 0.0]
      expect(pos).to eq([20.0, 0.0])
    end

    it 'translates by y' do
      t = described_class.translate_y 40
      pos = t * [0.0, 0.0]
      expect(pos).to eq([0.0, 40.0])
    end

    it 'translates by x and y' do
      t = described_class.translate_x 20
      t = t.translate_y(40)
      pos = t * [0.0, 0.0]
      expect(pos).to eq([20.0, 40.0])
    end

    it 'rotates by 90 degrees' do
      t = described_class.rotate 90
      pos = t * [1.0, 0.0]
      expect(pos[0]).to be_within(1e-16).of(0.0)
      expect(pos[1]).to be_within(1e-16).of(1.0)
    end
  end
end
