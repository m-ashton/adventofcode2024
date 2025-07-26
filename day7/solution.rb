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

def concat(x, y)
  (x.to_s + y.to_s).to_i
end

def can_be_true_part_two?(numbers, test_value)
  x = numbers[0]
  y = numbers[1]
  if numbers.count == 2
    x + y == test_value || x * y == test_value || concat(x, y) == test_value
  else
    add_numbers = [x + y] + numbers[2..]
    mult_numbers = [x * y] + numbers[2..]
    concat_numbers = [concat(x, y)] + numbers[2..]
    (x + y <= test_value && can_be_true_part_two?(add_numbers, test_value)) ||
      (x * y <= test_value && can_be_true_part_two?(mult_numbers, test_value)) ||
      (concat(x, y) <= test_value && can_be_true_part_two?(concat_numbers, test_value))
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
  puts equations.filter { |equation| can_be_true?(*equation) }.map { |equation| equation.last }.sum
end

def part2
  equations = read_input('./input.txt')
  puts equations.filter { |equation| can_be_true_part_two?(*equation) }.map { |equation| equation.last }.sum
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
