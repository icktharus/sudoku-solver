module Sudoku
  module Constraint
    class UniqueRowConstraint < Sudoku::Constraint::UniqueConstraint

      # Public: Creates a uniqueness constraint on each row of cells
      # in the board.
      #
      # board - Sudoku::Board whose rows will be constrained
      #
      # Returns array of UniqueRowConstraints
      def self.apply_to(board)
        rows = []
        board.each_cell do |cell|
          rows[ cell.position.y ] ||= []
          rows[ cell.position.y ] << cell
        end

        row_constraints = []
        rows.each do |row_cells|
          row_constraints << self.new(row_cells)
        end

        return row_constraints
      end

      # Public: Validates uniqueness of row.
      def validate
        super
      rescue Sudoku::Constraint::ConstraintError => e
        raise ConstraintError, e.message + " in a row"
      end

    end
  end
end
