def can_be_true?(numbers, test_value)
  x = numbers[0]
  y = numbers[1]
  if numbers.count == 2
    x + y == test_value || x * y == test_value
  else
    add_numbers = [x + y] + numbers[2..]
    mult_numbers = [x * y] + numbers[2..]
    (x + y <= test_value && can_be_true?(add_numbers, test_value)) ||
      (x * y <= test_value && can_be_true?(mult_numbers, test_value))
  end
end

def read_input(filename)
  lines = File.open(filename).readlines
  lines.map do |line|
    test_value, numbers = line.split(': ')
    [numbers.split.map(&:to_i), test_value.to_i]
  end
end

def part1
  equations = read_input('./input.txt')
  puts equations.inspect
  puts equations.filter { |equation| can_be_true?(*equation) }.map { |equation| equation.last }.sum
end

def part2
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
