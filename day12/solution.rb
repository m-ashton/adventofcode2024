def read_file(path)
  {}.tap do |grid|
    File.open(path).readlines.each.with_index do |line, y|
      line.chomp.chars.each.with_index do |char, x|
        grid[[x,y]] = char
      end
    end
  end
end

def build_region(grid, location, visited)
  if visited.include?(location)
    # puts "Already visited #{location.inspect}"
    return [0, 0]
  end
  name = grid[location]
  visited[location] = name
  perimeter = calculate_perimeter(grid, location)
  area = 1
  # FIXME: duplicated work on maxes/adjacencies
  max_x = grid.keys.max_by { |x, y| x }[0]
  max_y = grid.keys.max_by { |x, y| y }[1]
  adjacent_locations(location, max_x, max_y).each do |location|
    # puts "Visiting #{location.inspect}"
    if grid[location] == name
      additional_area, additional_perimeter, _ = build_region(grid, location, visited)
      # puts "Additional area for current region is #{additional_area}, additional perimeter is #{additional_perimeter}"
      perimeter += additional_perimeter
      area += additional_area
    end
  end

  [area, perimeter, visited]
end

def adjacent_locations(pos, max_x, max_y)
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

def calculate_perimeter(grid, location)
  max_x = grid.keys.max_by { |x, y| x }[0]
  max_y = grid.keys.max_by { |x, y| y }[1]
  adjacencies = adjacent_locations(location, max_x, max_y)
  region_edges =  adjacencies.count do |adjacent_location|
    grid[adjacent_location] != grid[location]
  end
  garden_edges = 4 - adjacencies.count
  region_edges + garden_edges
end

def part1
  grid = read_file('./input.txt')
  working_grid = grid.dup
  price = 0
  visited = {}
  working_grid.keys.each do |location|
    next if visited[location]
    area, perimeter, visited = build_region(grid, location, visited)
    # puts "built region #{grid[location]} with area #{area} and perimeter #{perimeter}}"
    price += (area * perimeter)
  end
  price
end

def part2

end
ARGV[0] == '2' ? puts(part2) : puts(part1)