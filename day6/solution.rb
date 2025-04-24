class LabMap
  attr_reader :num_rows, :num_columns, :grid
  attr_accessor :guard_pos, :direction

  DIRECTION_TO_VELOCITY = {
    '^' => [0, -1],
    '>' => [1, 0],
    'v' => [0, 1],
    '<' => [-1, 0],
  }


  def initialize(input)
    @grid = {}
    @direction = [
      '^',
      '>',
      'v',
      '<'
    ]
    rows = input.split("\n")
    @num_rows = rows.length
    @num_columns = rows.first.length
    rows.each.with_index do |row, y|
      row.chars.each.with_index do |c, x|
        if c == '#'
          @grid[[x,y]] = '#'
        elsif c != '.'
          @guard_pos = [x, y]
          @direction.rotate!(@direction.find_index(c))
        end
      end
    end
  end

  def move
    velocity = DIRECTION_TO_VELOCITY[@direction.first]
    next_pos = [@guard_pos[0] + velocity[0], @guard_pos[1] + velocity[1]]
    if @grid[next_pos] == '#'
      @direction.rotate!(1)
      velocity = DIRECTION_TO_VELOCITY[@direction.first]
      next_pos = [@guard_pos[0] + velocity[0], @guard_pos[1] + velocity[1]]
    end
    @guard_pos = next_pos
  end

  def guard_in_bounds?
    @guard_pos[0] < @num_columns &&
      @guard_pos[0] >= 0 &&
      @guard_pos[1] < @num_rows &&
      @guard_pos[1] >= 0
  end
end

def get_input(filename)
  LabMap.new(File.open(filename).read)
end

def part1
  map = get_input('input.txt')
  visited_locations = {}
  while map.guard_in_bounds?
    visited_locations[map.guard_pos] = 'x'
    map.move
  end
  visited_locations.count
end

def part2
  map = get_input('input.txt')
  loop_producing_obstacles = []
  while map.guard_in_bounds?
    # put an obstacle directly in the guard's way, run until you loop or
    # are off the map

    velocity = LabMap::DIRECTION_TO_VELOCITY[map.direction.first]
    obstacle_loc = map.guard_pos.zip(velocity).map(&:sum)
    if map.grid[obstacle_loc] == '#'
      map.move
      next
    end

    map.grid[obstacle_loc] = '#'
    visited_locations = {}
    visited_locations[map.guard_pos] = map.direction.first
    start_pos = map.guard_pos.dup
    start_direction = map.direction.dup
    while map.guard_in_bounds?
      map.move
      if visited_locations[map.guard_pos] == map.direction.first
        if loop_producing_obstacles.include?(obstacle_loc)
          puts "already found #{obstacle_loc}"
        end
        loop_producing_obstacles << obstacle_loc
        break
      end
      visited_locations[map.guard_pos] = map.direction.first
    end
    map.guard_pos = start_pos
    map.direction = start_direction
    map.grid.delete(obstacle_loc)
    map.move
  end
  loop_producing_obstacles.count
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
