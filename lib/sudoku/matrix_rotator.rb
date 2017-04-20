module Sudoku
  class MatrixRotator
    attr_accessor(:matrix)

    # Public: Instantiate an instance of a MatrixRotator with the
    # original matrix.
    #
    # matrix - array of array of integers/nils
    #
    # Returns new instance of Sudoku::MatrixRotator
    def initialize(matrix)
      self.matrix = matrix
    end

    # Public: Returns a rotated version of this matrix (rotating
    # clockwise).
    #
    # rotations - (integer) number of rotations to perform
    #
    # Returns a rotated array of array of integers/nils.
    def rotate(rotations)
      rotations = rotations % 4

      matrix = self.matrix
      (1..rotations).each do
        matrix = rotate_clockwise(matrix)
      end

      return matrix
    end

    # Public: Returns a reverse-rotated version of this matrix
    # (i.e. rotate counterclockwise).
    #
    # rotations - (integer) number of counterclockwise rotations to
    #             perform
    #
    # Returns a rotated array of array of integers/nils.
    def reverse_rotate(rotations)
      return self.rotate(0 - rotations)
    end

    # Private: rotates a matrix 90 degrees clockwise.
    #
    # matrix - array of array of integers/nils
    #
    # Returns rotates matrix (array of array of integers/nils)
    def rotate_clockwise(matrix)
      new_matrix = []

      matrix_height = matrix.size    rescue 0
      matrix_width  = matrix[0].size rescue 0

      matrix.each_with_index do |row, y|
        row.each_with_index do |value, x|
          new_x = matrix_height - 1 - y
          new_y = x

          new_matrix[new_y] ||= []
          new_matrix[new_y][new_x] = value
        end
      end

      return new_matrix
    end
  end
end
