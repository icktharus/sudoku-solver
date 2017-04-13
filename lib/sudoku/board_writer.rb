require 'csv'

module Sudoku
  class BoardWriter

    def initialize(board)
      @board = board
    end
    
    def write(filename)
      CSV.open(filename, 'wb') do |csv|
        @board.to_a.each do |row|
          csv << row.map{|cell| cell.nil? ? '-' : cell}
        end
      end
    end

  end
end
