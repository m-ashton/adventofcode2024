def read_file(path)
  Hash.new { |h, k| h[k] = 0 }.tap do |stone_counts|
    File.read(path).split.map(&:to_i).each do |stone|
      stone_counts[stone] += 1
    end
  end
end

def blink(stone)
  if stone == 0
    [1]
  elsif stone.digits.count.even?
    num_digits = stone.digits.count / 2
    [stone.digits.last(num_digits).map.with_index { |x, i| x * 10 ** i }.sum,
    stone.digits.first(num_digits).map.with_index { |x, i| x * 10 ** i }.sum]
  else
    [stone * 2024]
  end
end

def new_counts(stone_counts)
  Hash.new { |h, k| h[k] = 0 }.tap do |new_stone_counts|
    stone_counts.each do |stone, count|
      new_stones = blink(stone)
      new_stones.each do |new_stone|
        new_stone_counts[new_stone] += stone_counts[stone]
      end
    end
  end
end

def part1
  stone_counts = read_file('./input.txt')
  25.times do
    stone_counts = new_counts(stone_counts)
  end
  stone_counts.values.sum
end

def part2
  stone_counts = read_file('./input.txt')
  75.times do |i|
    stone_counts = new_counts(stone_counts)
  end
  stone_counts.values.sum
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
