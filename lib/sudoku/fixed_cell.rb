module Sudoku
  class FixedCell < Cell

    def initialize(position, value)
      super(position)
      self.value = value
    end

    def allowable_values(value_range)
      return [ @value ]
    end

  end
end
