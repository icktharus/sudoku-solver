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
      board_matrix = [ [ 9, 8, 6 ],
                       [ 5, 4, 3 ],
                       [ 2, 1, nil ] ]

      board = Sudoku::Board.new(3, 3, board_matrix)

      first_position  = Sudoku::BoardPosition.at(2,2)
      second_position = Sudoku::BoardPosition.at(1,2)

      expect(board.cell_at(first_position).value).to be(nil)
      expect(board.cell_at(first_position).class).to be(Sudoku::Cell)
      expect(board.cell_at(second_position).value).to eq(1)
      expect(board.cell_at(second_position).class).to eq(Sudoku::FixedCell)
    end
  end

  context(:cell_at) do
    it("should get correct cell") do
      board_matrix = [ [ nil, 1,   nil ],
                       [ 7,   4,   5 ],
                       [ nil, nil, nil  ] ]

      board = Sudoku::Board.new(3, 3, board_matrix)
      expect(board.rotations).to eq(0)
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

      expect(board.rotations).to eq(2)
      expect(board.raw_array).to eq([ [8, 7, 6], [5, 4, 3], [2, 1, nil] ])

      index = 0
      board.each_cell do |cell|
        case index
        when 8
          expect(cell.class).to eq(Sudoku::Cell)
          expect(cell.value).to be(nil)
        else
          expect(cell.class).to eq(Sudoku::FixedCell)
          expect(cell.value).to eq(8 - index)
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
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]
      board = Sudoku::Board.new(3, 3, board_matrix)

      constraint_class = class_double("TestConstraint")
      constraints = [ double(:honky), double(:tonk) ]
      expect(constraint_class).to receive(:apply_to).with(board).
        and_return(constraints)

      board.add_constraints([ constraint_class ])

      constraints.each do |constraint|
        expect(constraint).to receive(:validate)
      end

      board.constraints_valid?
    end
  end

  context(:to_a) do
    it("should produce correct output board") do
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]
      board = Sudoku::Board.new(3, 3, board_matrix)
      expect(board.to_a).to eq(board_matrix)
    end
  end
end
