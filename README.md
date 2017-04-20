# sudoku-solver

## Prerequisites

* ruby-1.9.2-p290
* `gem install bundler-1.0.21`
* `bundle install`

## Execution

Get options help:

```./bin/sudoku-solve --help```


Run on an input file, outputting to stdout:

```./bin/sudoku-solve data/easy-01.csv```

Run on an input file, outputting to a file:

```./bin/sudoku-solve data/easy-01.csv easy-01.solution.csv```


## Algorithm


This is a brute-force sudoku solver, which runs through all possible
numerical options for each cell in the sudoku board.

When the board is instantiated, it is set up with a number of
constraints (unique-rows, unique-columns, and unique-subboard (3x3)).
Each cell is associated with one of each constraint, and at any point,
the cell knows what it's possible values are, given all its
constraints.

Then, to solve it, the sudoku solver performs a depth-first tree
iteration of all possible numbers in the free cells.  The possible
numbers for a cell are dictated by the constraints for that cell: for
example, if a board looks like:

```
   - 1 2 - - - 8 - -
   - - 3 - - - - - 9
   - - - - - - - - -
   - - - - - - - - -
   - - - - - - - - -
   - - - - - - - - -
   - - - - - - - - -
   5 - - - - - - - -
   - - - - - - - - -
```

The allowable numbers for the first cell are:
```
  unique-row-constraint:            3, 4, 5, 6, 7,    9
  unique-column-constraint:   1, 2, 3, 4,    6, 7, 8, 9
  unique-subboard-constraint:          4, 5, 6, 7, 8, 9
```

So the actual allowable numbers for the first cell are: 4, 6, 7, and
9.

The solver then selects a 4 to try in the first cell, then moves down
to the next free cell and iterates through all possible options for
that cell (which, in turn, iterates through all possible options for
the next cell, etc).

## Design

### Sudoku::BoardPosition

A Sudoku::BoardPosition object represents the (x, y) coordinates of
each cell on the board.  Given the dimensions of a board, there's a
class method (`each_position`) to iterate through each position.


### Sudoku::Board

A Sudoku::Board consists of a Sudoku::Cell at each
Sudoku::BoardPosition on the Board.  A list of constraints (sub-clases
of Sudoku::Constraint::Base) can be applied to the board (each
constraint class applies itself to the appropriate cells of the board
and returns a list of Sudoku::Constraint objects).


### Sudoku::Cell

A Sudoku::Cell represents an individual cell in a Sudoku::Board.  It
has a Sudoku::BoardPosition, and has the ability to determine what its
allowable values are, given the current state of a board.

### Sudoku::FixedCell

A Sudoku::FixedCell represents an individual Sudoku::Cell in a
Sudoku::Board whose value has been predetermined in the input data.

### Sudoku::Solver

A Sudoku::Solver object is responsible for iterating through the tree
of possible solutions, and finding one that works.

### Sudoku::Constraint::Base

This is the base class for constraints on Sudoku::Cell values.  It
describes how the constraints are instantiated across the cells of a
board, whether the board is valid, and what the allowable values are
for a specific constraint.

#### Sudoku::Constraint::UniqueConstraint

This is an abstract sub-class of Sudoku::Constraint::Base, whose
objects apply uniqueness to the cells in its collection of
Sudoku::Cell objects.

#####  Sudoku::Constraint::UniqueRowConstraint

A UniqueRowConstraint is instantiated for each row of the Board, and
enforces uniqueness on the cells in its row.

##### Sudoku::Constraint::UniqueColumnConstraint

A UniqueColumnConstraint is instantiated for each column of the Board,
and enforces uniqueness on the cells in its column.

##### Sudoku::Constraint::UniqueSubboardConstraint

A UniqueColumnConstraint is instantiated for each 3x3 sub-board of the
Board, and enforces uniqueness on the cells in its 3x3 sub-board.


### Sudoku::BoardReader

A factory for Sudoku::Boards, this class constructs a Singleton object
which reads a CSV file containing a board, construsts a Sudoku::Board
from the data, applies the applicable Sudoku::Constraint classes, and
returns the constructed Sudoku::Board.

### Sudoku::BoardWriter

A factory for writing output CSV files.

### Sudoku::BoardError

An error representing any error in reading or parsing a board file, or
if the input-board has no solution.


## Tests

Run tests using bundle and rspec:

```bundle exec rspec```

