module Sudoku
  class Board
    attr_accessor(:cells_by_position, :rows, :cols, :constraints, :first_cell,
                  :rotations)

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

      rotated        = self.class.determine_best_rotation(board_matrix)
      rotated_board  = rotated[:board]
      rotations      = rotated[:rotations]

      self.rotations = rotations

      Sudoku::BoardPosition.each_position(width, height) do |position|
        # NOTE: I think in terms of (x, y), but arrays are structured
        # ARRAY[row][column], which means reversing x and y:
        value = rotated_board[position.y][position.x] rescue nil

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

    # Private: rotates the board 4 different ways, comparing how they
    # do in terms of number of fixed cells closer to the beginning,
    # and return the (theoretical) quickest rotation to iterate over.
    #
    # board_matrix - initial matrix (array of array of int/nil)
    #
    # returns hash with:
    #  :board     => rotated board_matrix (array of array of int/nil)
    #  :rotations => number of rotation (int)
    def self.determine_best_rotation(board_matrix)
      rotator = Sudoku::MatrixRotator.new(board_matrix)

      best_rotation      = 0
      best_rotated_board = board_matrix
      rotated_score      = rotation_score(board_matrix)

      (1..3).each do |rotation|
        rotated_board = rotator.rotate(rotation)
        this_board_score = rotation_score(rotated_board)

        if this_board_score > rotated_score
          rotated_score      = this_board_score
          best_rotation      = rotation
          best_rotated_board = rotated_board
        end
      end

      return {
        rotations: best_rotation,
        board:     best_rotated_board
      }
    end

    # Private: Scores each fixed board position by how far away from the
    # beginning of the iteration it is, and sums the scores.
    #
    # board_matrix - array of array of int/nil
    #
    # Returns score for this board.
    def self.rotation_score(board_matrix)
      score = 0

      board_height = board_matrix.size    rescue 0
      board_width  = board_matrix[0].size rescue 0

      board_matrix.each_with_index do |row, y|
        row.each_with_index do |value, x|
          if ! value.nil?
            add = ((board_height-1 - y) * board_width) + (board_width - x)
            score += add
          end
        end
      end

      return score
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

    # Public: Convert to an array of array of integers (for output),
    # applying reverse rotation.
    #
    # Returns array of array of integers.
    def to_a
      rotator = Sudoku::MatrixRotator.new(raw_array)
      return rotator.reverse_rotate(self.rotations)
    end

    # Private: Convert to an unrotated array of array of integers (for
    # output).
    #
    # Returns array of array of integers.
    def raw_array
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
