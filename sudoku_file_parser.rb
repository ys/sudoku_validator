class SudokuFileParser
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    [].tap do |grid|
      file.each_line do |line|
        chars = line.chars
        next if chars[0] == '-'
        grid << [].tap do |row|
          chars.each do |char|
            case char
            when /\d/ then row << Integer(char)
            when /\./ then row << nil
            when /[\+\-\|\s]/ then next
            else
              raise StandardError, 'problem with format'
            end
          end
        end
      end
      validate_grid(grid)
    end
  end

  def validate_grid(grid)
    raise(StandardError) if grid.size != 9
    grid.each do |row|
      raise(StandardError) if row.size != 9
    end
  end

  def file
    File.open(file_path)
  end
end
