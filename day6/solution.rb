require 'rainbow/refinement'
using Rainbow

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

  def print(overlay = {})
    (0...@num_rows).each do |y|
      puts((0...@num_columns).map do |x|
        if @guard_pos == [x, y]
          char = @direction.first.green
        elsif overlay[[x,y]]
          char = overlay[[x,y]].green
        elsif @grid[[x,y]] == '#'
          char = '#'.red
        else
          char = '.'
        end
        char
      end.join)
    end
    puts
  end

  def move
    velocity = DIRECTION_TO_VELOCITY[@direction.first]
    next_pos = [@guard_pos[0] + velocity[0], @guard_pos[1] + velocity[1]]
    while @grid[next_pos] == '#'
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
  map = get_input('sample.txt')
  visited_locations = {}
  while map.guard_in_bounds?
    visited_locations[map.guard_pos] = 'x'
    map.move
  end
  visited_locations.count
end

def part2
  map = get_input('input.txt')
  positions_with_loop = []
  (0...map.num_columns).each do |x|
    puts "testing column #{x}"
    (0...map.num_rows).each do |y|
      visited_locations = Hash.new { |h, k| h[k] = Array.new }
      next if map.grid[[x,y]] == '#' || map.grid[map.guard_pos] == '#'
      map.grid[[x,y]] = '#'
      while map.guard_in_bounds?
        visited_locations[map.guard_pos] << map.direction.first
        map.move
        if visited_locations[map.guard_pos].include?(map.direction.first)
          positions_with_loop << [x,y]
          # map.print(visited_locations)
          # puts "Found a loop starting at #{map.guard_pos}"
          break
        end
      end
      map = get_input('input.txt')
    end
  end
  positions_with_loop.count
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
