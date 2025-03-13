def main
  first_column = []
  second_column = []
  File.readlines('./input.txt').each do |line|
    a, b = line.split
    first_column << a.to_i
    second_column << b.to_i
  end

  first_column = first_column.sort
  second_column = second_column.sort

  puts(first_column.zip(second_column).map do |pair|
    (pair[0] - pair[1]).abs
  end.sum)

end

main if __FILE__ == $PROGRAM_NAME
