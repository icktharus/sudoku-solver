require 'spec_helper'

describe(Sudoku::Board) do
  context(:initialize) do
    it("should create new empty board") do
      board = Sudoku::Board.new(3, 3)

      expect(board.rows).to eq(3)
      expect(board.cols).to eq(3)
      expect(board.constraints).to eq([])

      expect(board.cells_by_position.keys.size).to eq(9)

      first_position = Sudoku::BoardPosition.at(0,0)
      expect(board.cells_by_position.keys).to include(first_position)
      expect(board.cells_by_position[first_position]).to eq(board.cell_at(first_position))

      board.cells_by_position.each_pair do |position, cell|
        expect(cell.value).to be(nil)
      end
    end

    it("should create new board from matrix") do
      board_matrix = [
        [ nil, 1, 2 ],
        [ 3, 4, 5 ],
        [ 6, 7, 8  ]
      ]
        
      board = Sudoku::Board.new(3, 3, board_matrix)

      first_position  = Sudoku::BoardPosition.at(0,0)
      second_position = Sudoku::BoardPosition.at(0,1)

      expect(board.cell_at(first_position).value).to be(nil)
      expect(board.cell_at(first_position).class).to be(Sudoku::Cell)
      expect(board.cell_at(second_position).value).to eq(1)
      expect(board.cell_at(second_position).class).to eq(Sudoku::FixedCell)
    end

  end
end
