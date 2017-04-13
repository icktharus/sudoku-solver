require 'spec_helper'

describe(Sudoku::FixedCell) do
  context(:allowable_values) do
    it("should have a fixed value and allowable_value") do
      fixed = Sudoku::FixedCell.new(Sudoku::BoardPosition.at(1,2), 3)
      expect(fixed.value).to eq(3)
      expect(fixed.allowable_values(1..9)).to eq([3])
    end
  end
end
