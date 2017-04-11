module Sudoku
  class Cell
	attr_accessor(:value, :position, :constraints)

	# Public: Adds a constraint that applies to this cell.
	#
	# constraint - instance of Sudoku::Constraint::Base subclass
	#
	# Returns nothing.
	def add_constraint(constraint)
	  self.constraints ||= []
	  self.constraints << constraint
	  return
	end

	# Public: Get a list of allowable values for this cell.
	#
	# value_range - range of allowable values for this cell.
	#
	# Returns array of allowable values (integers)
	def allowable_values(value_range)
	  allowable_values = value_range.to_a

	  self.constraints.each do |constraint|
		allowable_values = constraint.allowable_values(allowable_values)
	  end

	  return allowable_values
	end

  end
end
