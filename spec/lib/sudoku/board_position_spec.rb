require 'spec_helper'

describe(Sudoku::BoardPosition) do
  context(:each_position) do
    it("should iterate through each position") do
      count = 0

      positions = []
      Sudoku::BoardPosition.each_position(3, 2) do |position|
        positions << position
        count += 1
      end

      expect(count).to eq(6)

      # Expect each position between (0,0) and (1,2).
      (0..2).each do |expected_x|
        (0..1).each do |expected_y|
          expect(positions).to include(Sudoku::BoardPosition.at(expected_x, expected_y))
        end
      end
    end
  end
end
