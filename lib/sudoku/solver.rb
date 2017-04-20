module Sudoku
  class Solver

    def initialize(board, range)
      @board = board
      @range = range
    end

    def solve
      result = solve_for_cell(@board.first_cell)
      if ! result
        raise Sudoku::BoardError, "input board has no solution"
      end
    end

    def solve_for_cell(cell)
      # If this is a FixedCell, skip it.
      if cell.class == Sudoku::FixedCell
        if cell.next_cell.nil?
          return true
        else
          return self.solve_for_cell(cell.next_cell)
        end
      end

      if cell.next_cell.nil?
        # Leaf node.
        if cell.allowable_values(@range).size > 0
          cell.value = cell.allowable_values(@range).first
          return true
        else
          cell.value = nil
          return false
        end
      else
        # Branch node.
        if cell.allowable_values(@range).size > 0
          cell.allowable_values(@range).each do |value|
            cell.value = value

            # Try this value with further cells.
            if self.solve_for_cell(cell.next_cell)
              return true
            else
              # Continue the loop: keep trying more values.
              cell.value = nil
            end
          end

          # If we get here, it means none of our values succeeded.
          return false
        else
          cell.value = nil
          return false
        end
      end
    end
  end
end
