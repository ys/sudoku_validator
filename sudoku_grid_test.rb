$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'minitest/autorun'
require 'sudoku_grid'


def valid_grid
  [
    [8, 5, 9, 6, 1, 2, 4, 3, 7],
    [7, 2, 3, 8, 5, 4, 1, 6, 9],
    [1, 6, 4, 3, 7, 9, 5, 2, 8],
    [9, 8, 6, 1, 4, 7, 3, 5, 2],
    [3, 7, 5, 2, 6, 8, 9, 1, 4],
    [2, 4, 1, 5, 9, 3, 7, 8, 6],
    [4, 3, 2, 9, 8, 1, 6, 7, 5],
    [6, 1, 7, 4, 2, 5, 8, 9, 3],
    [5, 9, 8, 7, 3, 6, 2, 4, 1]
  ]
end

def valid_incomplete_grid
  [
    [8, 5, 9, nil, 1, 2, 4, 3, 7],
    [7, 2, 3, 8, 5, 4, 1, 6, 9],
    [1, 6, 4, 3, 7, 9, 5, 2, 8],
    [9, 8, 6, 1, 4, 7, 3, 5, 2],
    [3, 7, 5, 2, 6, 8, 9, 1, 4],
    [2, 4, 1, 5, 9, 3, 7, 8, 6],
    [4, 3, 2, 9, 8, 1, 6, 7, 5],
    [6, 1, 7, 4, 2, 5, 8, 9, 3],
    [5, 9, 8, 7, 3, 6, 2, 4, 1]
  ]
end

def sub_grids
  [
    [8, 5, 9, 7, 2, 3, 1, 6, 4],
    [6, 1, 2, 8, 5, 4, 3, 7, 9],
    [4, 3, 7, 1, 6, 9, 5, 2, 8],
    [9, 8, 6, 3, 7, 5, 2, 4, 1],
    [1, 4, 7, 2, 6, 8, 5, 9, 3],
    [3, 5, 2, 9, 1, 4, 7, 8, 6],
    [4, 3, 2, 6, 1, 7, 5, 9, 8],
    [9, 8, 1, 4, 2, 5, 7, 3 ,6],
    [6, 7, 5, 8, 9, 3, 2, 4, 1]
  ]
end

def invalid_grid
  [
    [1, 5, 7, 6, 1, 2, 4, 3, 7],
    [1, 2, 3, 8, 5, 4, 1, 6, 9],
    [1, 1, 4, 3, 7, 9, 5, 2, 8],
    [1, 8, 6, 1, 4, 7, 3, 5, 2],
    [1, 7, 5, 2, 6, 8, 9, 1, 4],
    [1, 4, 1, 5, 9, 3, 7, 8, 6],
    [1, 3, 2, 9, 8, 1, 6, 7, 5],
    [1, 1, 7, 4, 2, 5, 8, 9, 3],
    [1, 9, 8, 7, 3, 6, 2, 4, 1]
  ]
end

def invalid_incomplete_grid
  [
    [1, 5, 7, nil, 1, 2, 4, 3, 7],
    [1, 2, 3, 8, 5, 4, 1, 6, 9],
    [1, 1, 4, 3, 7, 9, 5, 2, 8],
    [1, 8, 6, 1, 4, 7, 3, 5, 2],
    [1, 7, 5, 2, 6, 8, 9, 1, 4],
    [1, 4, 1, 5, 9, 3, 7, 8, 6],
    [1, 3, 2, 9, 8, 1, 6, 7, 5],
    [1, 1, 7, 4, 2, nil, 8, 9, 3],
    [1, 9, 8, 7, 3, 6, 2, 4, 1]
  ]
end

describe SudokuGrid do
  describe '#new(array_of_array)' do
    it 'creates 9 rows with correct values' do
      grid = SudokuGrid.new(valid_grid)
      grid.rows.each_with_index do |row, i|
        assert_equal row.values, valid_grid[i]
      end
    end

    it 'creates 9 columns with correct values' do
      require 'matrix'
      grid = SudokuGrid.new(valid_grid)
      grid.columns.each_with_index do |column, i|
        assert_equal column.values, Matrix[*valid_grid].column(i).to_a
      end
    end

    it 'creates 9 sub grids with correct values' do
      grid = SudokuGrid.new(valid_grid)
      grid.sub_grids.each_with_index do |sub_grid, i|
        assert_equal sub_grid.values, sub_grids[i]
      end
    end
  end

  describe '#errors' do
    describe 'Grid is valid' do
      [valid_grid, valid_incomplete_grid].each do |ok_grid|
        it 'returns no errors' do
          grid = SudokuGrid.new(ok_grid)
          assert_equal grid.errors, {rows: [], columns: [], sub_grids: []}
        end
      end
    end

    describe 'Grid is invalid' do
      [invalid_grid, invalid_incomplete_grid].each do |not_ok_grid|
        it 'returns errors' do
          grid = SudokuGrid.new(not_ok_grid)
          assert_equal grid.errors, {rows:      [0, 1, 2, 3, 4, 5, 6, 7, 8],
                                     columns:   [0, 1, 2],
                                     sub_grids: [0, 3, 6]}
        end
      end
    end

  end

  describe '#valid?' do
    describe 'Grid is valid' do
      [valid_grid, valid_incomplete_grid].each do |ok_grid|
        it 'returns true' do
          grid = SudokuGrid.new(ok_grid)
          assert grid.valid?
        end
      end
    end
    describe 'Grid is invalid' do
      [invalid_grid, invalid_incomplete_grid].each do |ok_grid|
        it 'returns false' do
          grid = SudokuGrid.new(invalid_grid)
          refute grid.valid?
        end
      end
    end
  end
end

describe SudokuNine do
  describe '.new(items)' do
    it 'sets the values' do
      sn = SudokuNine.new([1, 2, 3])
      assert_equal sn.values, [1, 2, 3]
    end
  end

  describe '#<<(value)' do
    it 'adds a value' do
      sn = SudokuNine.new
      sn << 1
      assert_equal sn.values, [1]
    end
  end

  describe 'valid?' do
    it 'is true if row, column, or sub grid is valid' do
      sn = SudokuNine.new(valid_grid[0])
      assert sn.valid?
    end

    it 'is false if row, column, or sub grid is valid' do
      sn = SudokuNine.new(invalid_grid[0])
      refute sn.valid?
    end
  end
end

