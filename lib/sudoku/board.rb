module Sudoku
  class Board
    attr_accessor(:cells_by_position, :rows, :cols, :constraints)

    DEFAULT_WIDTH  = 9
    DEFAULT_HEIGHT = 9

    # Public: a Board represents a sudoku board to be solved.
    #
    # width - width of board (integer)
    # height - height of board (integer)
    # board_matrix - optional initialization board (2-d array of nil or integer)
    #
    # Returns new Sudoku::Board
    def initialize(width=DEFAULT_WIDTH, height=DEFAULT_HEIGHT, board_matrix=[])
      self.rows = width
      self.cols = height

      self.cells_by_position = {}
      self.constraints       = []

      Sudoku::BoardPosition.each_position(width, height) do |position|
        value = board_matrix[position.x][position.y] rescue nil

        cell = if value.nil?
                 Sudoku::Cell.new
               else
                 Sudoku::FixedCell.new(value)
               end
        self.cells_by_position[position] = cell
      end
    end

    # Public: Get the Sudoku::Cell at this Sudoku::BoardPosition
    #
    # position - Sudoku::BoardPosition
    #
    # Return Sudoku::Cell corresponding to this position
    def cell_at(position)
      return self.cells_by_position[position]
    end

    # Public: Iterates over each cell.
    #
    # block - code to iterate over each cell.
    #
    # Returns nothing.
    def each_cell(&block)
      self.cells_by_position.each_pair do |position, cell|
        block.call(cell)
      end

      return
    end

    # Public: Adds Sudoku::Constraint::Base subclasses to apply to
    # this Sudoku::Board
    #
    # constraints - array of Sudoku::Constraint::Base subclasses
    #
    # Returns nothing.
    def add_constraints(constraints)
      constraints.each do |constraint|
        self.constraints += constraint.apply_to(self)
      end

      return
    end

    # Public: Checks the constraints on this board to see if this
    # board is valid.
    #
    # Returns boolean.
    def constraints_valid?
      self.constraints.each do |constraint|
        if ! constraint.validate
          return false
        end
      end
      return true
    end
  end
end
