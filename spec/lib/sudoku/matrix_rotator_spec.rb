require 'spec_helper'

describe(Sudoku::MatrixRotator) do
  let(:input) { [ [1, 2, 3], [4, 5, 6], [7, 8, 9] ] }
  subject     { Sudoku::MatrixRotator.new(input)    }

  context(:rotate) do
    it("should call rotate_clockwise") do
      expect(subject).to receive(:rotate_clockwise).exactly(3).times.with(any_args)
      subject.rotate(3)

      expect(subject).to receive(:rotate_clockwise).exactly(2).times.with(any_args)
      subject.rotate(2)

      expect(subject).to receive(:rotate_clockwise).exactly(1).times.with(any_args)
      subject.rotate(1)

      expect(subject).not_to receive(:rotate_clockwise)
      subject.rotate(0)
    end


    it("should call rotate_clockwise 0-3 times") do
      expect(subject).to receive(:rotate_clockwise).exactly(3).times.with(any_args)
      subject.rotate(7)

      expect(subject).to receive(:rotate_clockwise).exactly(2).times.with(any_args)
      subject.rotate(6)

      expect(subject).to receive(:rotate_clockwise).exactly(1).times.with(any_args)
      subject.rotate(5)

      expect(subject).to receive(:rotate_clockwise).exactly(3).times.with(any_args)
      subject.rotate(-1)


      expect(subject).not_to receive(:rotate_clockwise)
      subject.rotate(4)
    end
  end

  context(:rotate_clockwise) do
    it("should rotate 3x3 array clockwise") do
      results = subject.rotate_clockwise(input)
      expect(results).to eq( [ [7, 4, 1], [8, 5, 2], [9, 6, 3] ] )
    end

    it("should rotate 4x2 array clockwise") do
      results = subject.rotate_clockwise([[1,2,3,4],[5,6,7,8]])
      expect(results).to eq( [ [5,1], [6,2], [7,3], [8,4] ] )
    end


    it("should equal 4x2 array rotated clockwise 4 times") do
      input_matrix = [[1,2,3,4],[5,6,7,8]]
      results = input_matrix.clone
      (1..4).each do
        results = subject.rotate_clockwise(results)
      end
      expect(results).to eq( input_matrix )
    end
  end

end
