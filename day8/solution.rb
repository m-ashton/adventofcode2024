def compute_antinodes(position_a, position_b)
  delta = [position_a[0] - position_b[0], position_a[1] - position_b[1]]
  [
    [position_a[0] + delta[0], position_a[1] + delta[1]],
    [position_b[0] - delta[0], position_b[1] - delta[1]]
  ]
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
        antinode[0] >= 0 && antinode[0] < width &&
          antinode[1] >= 0 && antinode[1] < height
      end
      antinodes.merge(inbounds_antinodes)
    end
  end
  puts antinodes.count
end

def part2
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
