require 'singleton'

module Sudoku
  class BoardReader
    include Singleton

    SUDOKU_CONSTRAINTS = [
      Sudoku::Constraint::UniqueSubboardConstraint,
      Sudoku::Constraint::UniqueRowConstraint,
      Sudoku::Constraint::UniqueColumnConstraint
    ]

    def read(filename)
      board = self.parse( File.read(filename) )
      board.add_constraints(SUDOKU_CONSTRAINTS)
      return board
    end

    def parse(string)
      rows = -1
      cols = -1

      board_matrix = []
      string.split(/\r?\n/).each do |line|
        elements = line.split(/\s*\-\s*/).map{|el| el == "-" ? nil : el}

        next if elements.size == 0

        if cols == -1
          cols = elements.size
        else
          if elements.size != cols
            raise Sudoku::BoardError, "incorrect board format: mismatched row sizes."
          end
        end

        board_matrix << elements
        rows += 1
      end

      board = Sudoku::Board.new(rows, cols, board_matrix)
      if ! board.constraints_valid?
        raise Sudoku::BoardError, "input board already fail Sudoku constraints."
      end
      return board
    end
    
  end
end
