def get_columns_from_file(filename)
  first_column = []
  second_column = []

  File.foreach(filename) do |line|
    a, b = line.split
    first_column << a.to_i
    second_column << b.to_i
  end

  [first_column, second_column]
end

def part1
  first_column, second_column = get_columns_from_file('./input.txt').map(&:sort!)

  first_column.zip(second_column).map do |pair|
    (pair[0] - pair[1]).abs
  end.sum
end

def part2
  first_column, second_column = get_columns_from_file('./input.txt').map(&:sort!)

  first_column.sum do |id|
    id * second_column.count { |x| x == id }
  end
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
