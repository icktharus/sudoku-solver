require 'csv'

module Sudoku
  class BoardWriter

    def initialize(board)
      @board = board
    end
    
    def write(filename)
      csv = if filename == "-"
              CSV($stdout)
            else
              CSV.open(filename, "wb")
            end

      begin
        @board.to_a.each do |row|
          csv << row.map{|cell| cell.nil? ? '-' : cell}
        end
      ensure
        csv.close
      end
    end

  end
end
