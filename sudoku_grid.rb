class SudokuGrid
  attr_reader :rows, :columns, :sub_grids
  def initialize(sudoku_array)
    @rows, @columns, @sub_grids = [], [], []
    sudoku_array.each_with_index do |row, row_number|
      @rows[row_number] = SudokuNine.new(row)
      row.each_with_index do |value, column_number|
        (@columns[column_number] ||= SudokuNine.new) << value
        (@sub_grids[sub_grid_number(row_number, column_number)] ||= SudokuNine.new) << value
      end
    end
  end

  def errors
    { rows:      erroneous_sub_part(@rows),
      columns:   erroneous_sub_part(@columns),
      sub_grids: erroneous_sub_part(@sub_grids) }
  end

  def erroneous_sub_part(collection)
    collection.each_with_index.map{ |nine, i| i unless nine.valid? }.compact
  end

  def valid?
    @rows.map(&:valid?).all? &&
    @columns.map(&:valid?).all? &&
    @sub_grids.map(&:valid?).all?
  end

  def sub_grid_number(row_number, column_number)
    (column_number / 3) + 3 * (row_number / 3)
  end
end

class SudokuNine
  attr_reader :values

  def initialize(numbers = nil)
    @values = numbers || []
  end

  def <<(value)
    @values << value
  end

  def valid?
    # the & returns all the elements from the first array that are also in the
    # second one. It removes also duplicates if there are some
    #we compare the compacted, because nil does not count for validity
    (@values.compact & (1..9).to_a) == @values.compact
  end
end
