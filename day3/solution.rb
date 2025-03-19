def get_input(filename)
  File.open(filename) do |f|
    f.readlines.join
  end
end

def part1
  # for each character in input string
  # expect m, if m expect u, if u expect l, if (, etc.
  # if unexpected, go back to expecting m
  program = get_input('./input.txt')
  segment = program
  start_pos = 0
  total = 0
  loop do
    start_pos = /mul\((\d{1,3}),(\d{1,3})\)/ =~ segment
    break unless start_pos
    total += $1.to_i * $2.to_i
    segment = segment[start_pos + 6 + $1.length + $2.length..-1]
  end

  total
end

def part2
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
