# frozen_string_literal: true

require 'optparse'

require_relative 'assignment/dsl'
require_relative 'canvas'
require_relative 'rng'

seed = nil
fps = 60
incr = 1
OptionParser.new do |parser|
  parser.banner = 'Usage: main.rb [OPTION]... FILE'

  parser.on('-sSEED', '--seed=SEED', Integer, 'Seed for random number generator') do |s|
    seed = s
  end

  parser.on('-fFPS', '--fps=FPS', Integer, 'Set the FPS limit') do |f|
    fps = f
  end

  parser.on('-iSTEPS', '--incr=STEPS', Integer, 'The number of evaluation steps to perform per update') do |i|
    incr = i
  end
end.parse!

filename = ARGV.pop
raise 'Need to specify a file' unless filename
raise 'File does not exist' unless File.exist? filename

ContextFree::DSL.grammar.rng = ContextFree::RNG.new seed

load filename, ContextFree::DSL

ContextFree::Canvas.new(ContextFree::DSL.grammar, fps_limit: fps, steps_per_update: incr).show
