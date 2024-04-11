# frozen_string_literal: true

require_relative 'grammar'

module ContextFree
  # The DSL module provides a context in which the DSL code is evaluated
  module DSL
    @@grammar = Grammar.new

    class << self
      # Returns the grammar associated with the DSL
      # @return [Grammar]
      def grammar
        @@grammar
      end

      # Resets the grammar associated with the DSL,
      # so that the DSL module can be reused.
      def reset
        @@grammar = Grammar.new
      end
    end
  end
end
