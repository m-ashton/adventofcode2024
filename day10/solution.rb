def read_file(path)
  {}.tap do |grid|
    File.readlines(path).map.with_index do |line, y|
      line.chomp.chars.map.with_index do |char, x|
        grid[[x,y]] = char.to_i
      end
    end
    max_x = grid.keys.max { |pos| pos[0] }[0]
    max_y = grid.keys.max { |pos| pos[1] }[1]
    grid[:max_x] = max_x
    grid[:max_y] = max_y
  end
end

def walk(pos, grid)
  if grid[pos] == 9
    Set.new([pos])
  else
    Set.new.tap do |nines|
      adjacent_positions(pos, grid[:max_x], grid[:max_y]).each do |adjacent_pos|
        if grid[adjacent_pos] == grid[pos] + 1
          nines.merge(walk(adjacent_pos, grid))
        end
      end
    end
  end
end

def score(pos, grid)
  if grid[pos] != 0
    0
  else
    walk(pos, grid).count
  end
end

def adjacent_positions(pos, max_x, max_y)
  [
    [pos[0], pos[1] - 1],
    [pos[0], pos[1] + 1],
    [pos[0] - 1, pos[1]],
    [pos[0] + 1, pos[1]],
  ].reject do |pos|
    pos[0] < 0 ||
    pos[1] < 0 ||
    pos[0] > max_x ||
    pos[1] > max_y
  end
end

def part1
  grid = read_file('./input.txt')
  puts(grid.keys.sum { |pos| score(pos, grid) })
end

def part2

end

ARGV[0] == '2' ? puts(part2) : puts(part1)
