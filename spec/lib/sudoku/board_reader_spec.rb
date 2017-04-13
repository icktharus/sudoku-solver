require 'spec_helper'
require 'tempfile'

describe(Sudoku::BoardReader) do

  subject { Sudoku::BoardReader.instance }

  context(:read) do
    it("should read a valid board file") do
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]

      board_matrix_string = board_matrix.map do |row|
        row.map{|el| el.nil? ? '-' : el}.join(",")
      end.join("\n")

      Tempfile.open("board") do |file|
        file.write(board_matrix_string)
        file.rewind

        board = subject.read(file.path)
        expect(board.to_a).to eq(board_matrix)
      end
    end

    it("should raise error when reading an invalid board file") do
      board_matrix = [ [ 1, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]

      board_matrix_string = board_matrix.map do |row|
        row.map{|el| el.nil? ? '-' : el}.join(",")
      end.join("\n")

      Tempfile.open("board") do |file|
        file.write(board_matrix_string)
        file.rewind

        expect{ subject.read(file.path) }.to raise_error(Sudoku::BoardError)
      end
    end
  end

  context(:parse) do
    it("should parse valid board string") do
      board_matrix = [ [ nil, 1, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]

      board_matrix_string = board_matrix.map do |row|
        row.map{|el| el.nil? ? '-' : el}.join(",")
      end.join("\n")

      board = subject.parse(board_matrix_string)
      expect(board.to_a).to eq(board_matrix)
    end

    it("should raise error when parsing invalid board data") do
      board_matrix = [ [ nil, 2 ],
                       [ 3, 4, 5 ],
                       [ 6, 7, 8  ] ]

      board_matrix_string = board_matrix.map do |row|
        row.map{|el| el.nil? ? '-' : el}.join(",")
      end.join("\n")

      expect{ subject.parse(board_matrix_string) }.to raise_error(Sudoku::BoardError)
      
    end
  end
end

