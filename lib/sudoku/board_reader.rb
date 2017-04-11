require 'singleton'

module Sudoku
  class BoardReader
    include Singleton

    def read(filename)
      return self.parse( File.read(filename) )
    end

    def parse(string)
      rows = -1
      cols = -1

      board_matrix = []
      string.split(/\r?\n/).each do |line|
        elements = line.split(/\s*\-\s*/).map{|el| el == "-" ? nil : el}

        next if elements.size == 0

        if cols == -1
          cols = elements.size
        else
          if elements.size != cols
            raise Sudoku::BoardError, "incorrect board format: mismatched row sizes."
          end
        end

        board_matrix << elements
        rows += 1
      end

      return Sudoku::Board.new(rows, cols, board_matrix)
    end
    
  end
end