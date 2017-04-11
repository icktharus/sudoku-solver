module Sudoku
  class FixedCell < Cell

    def initialize(value)
      self.value = value
    end

    def allowable_values(value_range)
      return [ @value ]
    end

  end
end
