def read_file(path)
  File.read(path).split.map(&:to_i)
end

def blink(stones)
    stones.flat_map do |stone|
      if stone == 0
        1
      elsif stone.digits.count.even?
        num_digits = stone.digits.count / 2
        # FIXME: why are the digits reversed? Is there a cleaner way than join.to_i ?
        [stone.digits.reverse.first(num_digits).join.to_i,
        stone.digits.reverse.last(num_digits).join.to_i]
      else
        stone * 2024
      end
    end
end

def part1
  stones = read_file('./input.txt')
  25.times do
    stones = blink(stones)
  end
  stones.count
end

def part2
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
