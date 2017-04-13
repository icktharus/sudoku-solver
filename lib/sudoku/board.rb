module Sudoku
  class Board
    attr_accessor(:cells_by_position, :rows, :cols, :constraints, :first_cell)

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

      last_cell = nil

      Sudoku::BoardPosition.each_position(width, height) do |position|
        # NOTE: I think in terms of (x, y), but arrays are structured
        # ARRAY[row][column], which means reversing x and y:
        value = board_matrix[position.y][position.x] rescue nil

        cell = if value.nil?
                 Sudoku::Cell.new(position)
               else
                 Sudoku::FixedCell.new(position, value)
               end
        self.cells_by_position[position] = cell
        if last_cell.nil?
          self.first_cell = cell
        else
          last_cell.next_cell = cell
        end

        last_cell = cell
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
        constraint.validate
      end
      return true
    end

    # Public: Convert to an array of array of integers (for output).
    #
    # Returns array of array of integers.
    def to_a
      array = []
      (0..self.rows-1).each do |y|
        row = []
        (0..self.cols-1).each do |x|
          position = Sudoku::BoardPosition.at(x, y)
          cell = self.cell_at(position)
          row << cell.value
        end
        array << row
      end
      return array
    end

  end
end
