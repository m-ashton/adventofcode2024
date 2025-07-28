def compute_antinodes(position_a, position_b)
  delta = [position_a[0] - position_b[0], position_a[1] - position_b[1]]
  [
    [position_a[0] + delta[0], position_a[1] + delta[1]],
    [position_b[0] - delta[0], position_b[1] - delta[1]]
  ]
end

def compute_antinodes_part_2(position_a, position_b, width, height)
  delta = [position_a[0] - position_b[0], position_a[1] - position_b[1]]
  antinodes = [position_a, position_b]
  next_a = [position_a[0] + delta[0], position_a[1] + delta[1]]
  while in_bounds?(next_a, width, height)
    antinodes.append(next_a)
    next_a = [next_a[0] + delta[0], next_a[1] + delta[1]]
  end

  next_b = [position_b[0] - delta[0], position_b[1] - delta[1]]
  while in_bounds?(next_b, width, height)
    antinodes.append(next_b)
    next_b = [next_b[0] - delta[0], next_b[1] - delta[1]]
  end
  antinodes
end

def in_bounds?(pos, width, height)
  pos[0] >= 0 && pos[0] < width && pos[1] >= 0 && pos[1] < height
end

def read_input(filename)
  grid = Hash.new { |h, k| h[k] = Array.new }
  lines = File.open(filename).readlines.map(&:strip)
  lines.each.with_index do |line, y|
    line.strip.chars.each.with_index do |c, x|
      grid[c] << [x, y] if c != '.'
    end
  end
  width = lines.first.chars.count
  height = lines.count
  [grid, width, height]
end

def part1
  grid, width, height = read_input('./input.txt')
  antinodes = Set.new
  grid.each do |_, positions|
    positions.combination(2) do |antenna_pair|
      candidate_antinodes = compute_antinodes(*antenna_pair)
      inbounds_antinodes = candidate_antinodes.filter do |antinode|
        in_bounds?(antinode, width, height)
      end
      antinodes.merge(inbounds_antinodes)
    end
  end
  puts antinodes.count
end

def part2
  grid, width, height = read_input('./input.txt')
  antinodes = Set.new
  grid.each do |_, positions|
    positions.combination(2) do |antenna_pair|
      candidate_antinodes = compute_antinodes_part_2(*antenna_pair, width, height)
      antinodes.merge(candidate_antinodes)
    end
  end
  puts antinodes.count
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
