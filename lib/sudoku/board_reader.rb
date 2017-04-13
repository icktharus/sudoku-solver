require 'singleton'
require 'csv'

module Sudoku
  class BoardReader
    include Singleton

    SUDOKU_CONSTRAINTS = [
      Sudoku::Constraint::UniqueSubboardConstraint,
      Sudoku::Constraint::UniqueRowConstraint,
      Sudoku::Constraint::UniqueColumnConstraint
    ]

    def read(filename)
      input_string = if filename == "-"
                       $stdin.read
                     else
                       File.read(filename)
                     end

      board = self.parse( input_string )
      board.add_constraints(SUDOKU_CONSTRAINTS)
      begin
        board.constraints_valid?
      rescue Sudoku::Constraint::ConstraintError => e
        raise Sudoku::BoardError, "input board already fail Sudoku constraints: #{e.message}"
      end
      return board
    end

    def parse(string)
      rows = 0
      cols = -1

      board_matrix = []

      CSV.parse(string) do |row|
        elements = row.map{|el| el == "-" ? nil : el.to_i}

        # Skip blank lines.
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
      return board
    end
    
  end
end
