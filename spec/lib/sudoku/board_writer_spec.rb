require 'spec_helper'
require 'tempfile'

describe(Sudoku::BoardWriter) do
  context(:write) do
    it("should write file from a board") do
      tmpfile = Tempfile.new("board")

      board_matrix = [ [nil, 1, nil],
                       [3, 4, 5],
                       [6, 7, nil] ]
      board  = Sudoku::Board.new(3, 3, board_matrix)

      writer = Sudoku::BoardWriter.new(board)
      writer.write(tmpfile.path)

      board_contents = nil
      begin
        f = tmpfile.open
        board_contents = f.read
      ensure
        tmpfile.close
        tmpfile.unlink
      end

      board_matrix_string = board_matrix.map do |row|
        row.map{|el| el.nil? ? '-' : el}.join(",")
      end.join("\n") + "\n"

      expect(board_contents).to eq(board_matrix_string)
    end
  end
end
