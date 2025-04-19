class LabMap
  attr_reader :num_rows, :num_columns, :guard_pos, :grid, :direction

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
      @guard_pos[0] >= 0
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
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
