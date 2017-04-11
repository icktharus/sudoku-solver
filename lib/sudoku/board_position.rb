module Sudoku
  class BoardPosition
    attr_accessor(:x, :y)

    # Public: iterator for each position available for a board of the
    # specified size.
    #
    # width - board width (integer)
    # height - board height (integer)
    # block - code block to iterate over each position
    #
    # Returns nothing.
    def self.each_position(width, height, &block)
      if ! block_given?
        raise RuntimeError, "no block passed to #each_position"
      end

      (0..width-1).each do |x_position|
        (0..height-1).each do |y_position|
          position = self.at( x_position, y_position )
          block.call(position)
        end
      end

      return
    end

    # Public: returns the position at this (x,y) location,
    # instantiating one if it doesn't exist.
    #
    # x - x position (integer)
    # y - y position (integer)
    #
    # Returns BoardPosition.
    def self.at(x, y)
      @existing_positions ||= {}
      @existing_positions[x] ||= {}
      @existing_positions[x][y] ||= self.new(x,y)
      return @existing_positions[x][y]
    end

    # Private: a BoardPosition represents a position on a 2-dimensional
    # board (x,y)
    #
    # x - x position (integer)
    # y - y position (integer)
    #
    # Returns new BoardPosition
    def initialize(x, y)
      self.x = x
      self.y = y
    end

  end
end
