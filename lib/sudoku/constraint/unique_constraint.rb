module Sudoku
  module Constraint
    class UniqueConstraint < Sudoku::Constraint::Base

      # Public : Validates whether the values are unique.
      #
      # Returns true or raises ConstraintError.
      def validate
        seen_values = Set.new
        self.cells.each do |cell|
          if ! cell.value.nil? && seen_values.include?(cell.value)
            raise ConstraintError, "#{cell.value} seen twice"
          end
          seen_values << cell.value
        end

        return true
      end

      # Public: Returns a list of allowables values for this given
      # constraint, given the existing values for cells.
      #
      # allowable_values - potential values to choose from (array of ints)
      #
      # Returns array of values (integers)
      def allowable_values(allowable_values)
        seen_values = Set.new
        self.cells.each do |cell|
          seen_values << cell.value
        end
        return allowable_values - seen_values.to_a
      end

    end
  end
end
