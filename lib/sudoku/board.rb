module Sudoku
  class Board
	attr_accessor(:cells_by_position, :rows, :cols, :constraints)

	DEFAULT_WIDTH  = 9
	DEFAULT_HEIGHT = 9

	# Public: a Board represents a sudoku board to be solved.
	#
	# width - width of board (integer)
	# height - height of board (integer)
	#
	# Returns new Sudoku::Board
	def initialize(width=DEFAULT_WIDTH, height=DEFAULT_HEIGHT)
	  self.rows = width
	  self.cols = height

	  self.cells_by_position = {}
	  self.constraints       = []

	  Sudoku::BoardPosition.each_position(width, height) do |position|
		self.cells_by_position[position] = Sudoku::Cell.new
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

  end
end
