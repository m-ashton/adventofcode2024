def get_columns_from_file(filename)
  first_column = []
  second_column = []

  File.foreach('./input.txt') do |line|
    a, b = line.split
    first_column << a.to_i
    second_column << b.to_i
  end

  [first_column, second_column]
end

def main
  first_column, second_column = get_columns_from_file('./input.txt').map(&:sort!)

  puts(first_column.zip(second_column).map do |pair|
    (pair[0] - pair[1]).abs
  end.sum)

end

main if __FILE__ == $PROGRAM_NAME
