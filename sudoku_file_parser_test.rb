$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'minitest/autorun'
require 'sudoku_file_parser'

describe SudokuFileParser do
  describe '#parse(file_path)' do
    it 'raise an exception on invalid grid' do
      parser = SudokuFileParser.new('./invalid.sudoku')
      proc { parser.parse }.must_raise StandardError
    end

    it 'raise an exception on invalid grid' do
      parser = SudokuFileParser.new('./invalid_chars.sudoku')
      proc { parser.parse }.must_raise StandardError
    end

    %w[./invalid_complete.sudoku ./invalid_incomplete.sudoku ./valid_complete.sudoku ./valid_incomplete.sudoku].each do |file_path|
      before do
        parser = SudokuFileParser.new(file_path)
        @sudoku = parser.parse
      end
      it 'returns the grid as an array of array' do
        assert_equal @sudoku.size, 9
        @sudoku.each do |row|
          assert_equal row.size, 9
        end
      end

      it 'contains only numbers or nil' do
        @sudoku.flatten.each do |item|
          assert_includes (0..9).to_a + [nil], item
        end
      end
    end
  end
end
