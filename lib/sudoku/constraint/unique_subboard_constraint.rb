module Sudoku
  module Constraint
    class UniqueSubboardConstraint < Sudoku::Constraint::UniqueConstraint

      def self.apply_to(board)
        sub_boards = {}

        board.each_cell do |cell|
          position = self.subboard_position_for(cell)
          sub_boards[position] ||= []
          sub_boards[position] << cell
        end

        constraints = []
        sub_boards.each_pair do |position, cells|
          constraints << self.new(cells)
        end

        return constraints
      end

      def self.subboard_position_for(cell)
        x_position = (cell.position.x.to_f / 3.0).floor
        y_position = (cell.position.y.to_f / 3.0).floor

        sub_board_position = Sudoku::BoardPosition.at(x_position, y_position)
        return sub_board_position
      end


      # Public: Validates uniqueness of subboard.
      def validate
        super
      rescue Sudoku::Constraint::ConstraintError => e
        raise ConstraintError, e.message + " in a 3x3 subboard"
      end

    end
  end
end
