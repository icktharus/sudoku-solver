module Sudoku
  module Constraint
	class Base
	  attr_accessor(:cells)

	  # Public: Apply this Constraint class to a Sudoku::Board,
	  # returning an array of individual constraints that apply.
	  #
	  # board - Sudoku::Board instance
	  #
	  # Returns list of Constraint instances.
	  def self.apply_to(board)
		raise RuntimeError, "#{self.to_s} does not implement #apply_to"
		return []
	  end

	  # Public: Initialize this Constraint with the list of cells that
	  # it pertains to.
	  #
	  # cells - array of Sudoku::Cell objects
	  #
	  # Returns new Constraint object
	  def initialize(cells)
		self.cells = cells

		# Make the reverse link: each cell knows what constraints
		# applies to it.
		cells.each do |cell|
		  cell.add_constraint(self)
		end
	  end

	  # Public: Validates whether this Constraint holds for the Cells
	  # it applies to.
	  #
	  # Returns boolean.
	  def validate
		raise RuntimeError, "#{self.class.to_s} does not implement #validate"
	  end

	  # Public: Returns a list of allowables values for this constraint.
	  #
	  # Returns array of values (integers)
	  def allowable_values(allowable_range)
		raise RuntimeError, "#{self.class.to_s} does not implement #allowable_values"
	  end

	end
  end
end
