require 'spec_helper'

describe(Sudoku::Solver) do
  let(:board) do
    board_matrix = [ [ nil, 1, 2 ],
                     [ 3, 4, 5],
                     [ 6, 7, 8 ] ]
    Sudoku::Board.new(3, 3, board_matrix)
  end

  subject do
    Sudoku::Solver.new(board, (1..9))
  end

  context(:solve) do
    it("should fill in blank") do
      subject.solve
      # With no constraints, it fills in with 1's.
      expect(board.to_a).to eq([ [1,1,2],[3,4,5],[6,7,8] ])
    end

    it("should fill in blank with unique numbers") do
      board.add_constraints([ Sudoku::Constraint::UniqueSubboardConstraint ])
      subject.solve
      # With uniqueness constraint, it fills the blank in with 9.
      expect(board.to_a).to eq([ [9,1,2],[3,4,5],[6,7,8] ])
    end      

    it("should fill in blank with unique row number") do
      board.add_constraints([ Sudoku::Constraint::UniqueRowConstraint ])
      subject.solve
      expect(board.to_a).to eq([ [3,1,2], [3,4,5], [6,7,8] ])
    end

    it("should fill in blank with unique column number") do
      board.add_constraints([ Sudoku::Constraint::UniqueColumnConstraint ])
      subject.solve
      expect(board.to_a).to eq([ [1,1,2], [3,4,5], [6,7,8] ])
    end
  end
end
