def get_input(filename)
  [].tap do |grid|
    File.foreach(filename) do |line|
      grid << line.chomp.chars
    end
  end
end

def part1
  grid = get_input('./input.txt')
  xmas_count = 0
  grid.each.with_index do |row, y|
    row.each.with_index do |char, x|
      if char == 'X'
        (-1..1).each do |delta_x|
          (-1..1).each do |delta_y|
            if (0...grid[y].length).include?(x + (delta_x * 3)) &&
                (0...grid.length).include?(y + (delta_y * 3)) &&
                grid[y + delta_y][x + delta_x] == 'M' &&
                grid[y + (delta_y * 2)][x + (delta_x * 2)] == 'A' &&
                grid[y + (delta_y * 3)][x + (delta_x * 3)] == 'S'
              xmas_count += 1
            end
          end
        end
      end
    end
  end
  xmas_count
end

def part2
  grid = get_input('./input.txt')
  xmas_count = 0
  grid.each.with_index do |row, y|
    row.each.with_index do |char, x|
      if char == 'A'
        mas_count = 0
        [[-1, -1], [1, -1]].each do |delta_x, delta_y|
          in_bounds = (0...grid[y].length).include?(x + delta_x) &&
            (0...grid[y].length).include?(x - delta_x) &&
            (0...grid.length).include?(y + delta_y) &&
            (0...grid.length).include?(y - delta_y)
          if in_bounds
            letter = grid[y + delta_y][x + delta_x]
            desired_letters = ['M', 'S']
            if desired_letters.delete(letter) && grid[y - delta_y][x - delta_x] == desired_letters.first
              mas_count += 1
            end
          end
        end
        xmas_count += 1 if mas_count == 2
      end
    end
  end
  xmas_count
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
