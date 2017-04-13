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
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]

      board = Sudoku::Board.new(3, 3, board_matrix)

      first_position  = Sudoku::BoardPosition.at(0,0)
      second_position = Sudoku::BoardPosition.at(1,0)

      expect(board.cell_at(first_position).value).to be(nil)
      expect(board.cell_at(first_position).class).to be(Sudoku::Cell)
      expect(board.cell_at(second_position).value).to eq(1)
      expect(board.cell_at(second_position).class).to eq(Sudoku::FixedCell)
    end
  end

  context(:cell_at) do
    it("should get correct cell") do
      board_matrix = [ [ nil, 1, nil ],
                       [ nil, nil, 5 ],
                       [ nil, nil, 8  ] ]

      board = Sudoku::Board.new(3, 3, board_matrix)
      position = Sudoku::BoardPosition.at(2, 1)
      expect(board.cell_at(position).value).to eq(5)
    end
  end

  context(:each_cell) do
    it("should iterate over each cell") do
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]

      board = Sudoku::Board.new(3, 3, board_matrix)

      index = 0
      board.each_cell do |cell|
        case index
        when 0
          expect(cell.class).to eq(Sudoku::Cell)
          expect(cell.value).to be(nil)
        else
          expect(cell.class).to eq(Sudoku::FixedCell)
          expect(cell.value).to eq(index)
        end

        index += 1
      end
    end
  end

  context(:add_constraints) do
    it("should apply constraint to board") do
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]
      board = Sudoku::Board.new(3, 3, board_matrix)

      constraint = class_double("TestConstraint")
      expect(constraint).to receive(:apply_to).with(board).
        and_return([ :honky, :tonk ])

      board.add_constraints([ constraint ])
      expect(board.constraints).to eq([:honky, :tonk])
    end
  end

  context(:constraints_valid?) do
    it("should check board against all constraints") do
    end
  end
end
