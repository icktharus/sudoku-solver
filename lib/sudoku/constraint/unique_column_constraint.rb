module Sudoku
  module Constraint
    class UniqueColumnConstraint < Sudoku::Constraint::UniqueConstraint

      # Public: Creates a uniqueness constraint on each column of cells
      # in the board.
      #
      # board - Sudoku::Board whose columns will be constrained
      #
      # Returns array of UniqueColumnConstraints
      def self.apply_to(board)
        columns = []
        board.each_cell do |cell|
          columns[ cell.position.x ] ||= []
          columns[ cell.position.x ] << cell
        end

        col_constraints = []
        columns.each do |col_cells|
          col_constraints << self.new(col_cells)
        end

        return col_constraints
      end

      # Public: Validates uniqueness of column.
      def validate
        super
      rescue Sudoku::Constraint::ConstraintError => e
        raise ConstraintError, e.message + " in a column"
      end
    end
  end
end
