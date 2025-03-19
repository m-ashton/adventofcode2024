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
    segment = segment[start_pos + "mul(#{1},#{2})".length..-1]
  end

  total
end

def part2
  program = get_input('./input.txt')
  segment = program
  start_pos = 0
  total = 0
  enabled = true
  loop do
    next_mul = /mul\((\d{1,3}),(\d{1,3})\)/ =~ segment
    first, second = [$1, $2]
    break unless next_mul
    next_do = /do\(\)/ =~ segment
    next_dont = /don't\(\)/ =~ segment
    if !enabled && next_do && next_do < next_mul
      enabled = true
      start_pos = next_do + "do()".length
    elsif enabled && next_dont && next_dont < next_mul
      enabled = false
      start_pos = next_mul + "mul(#{first},#{second})".length
    elsif enabled
      total += first.to_i * second.to_i
      start_pos = next_mul + "mul(#{first},#{second})".length
    else
      start_pos = next_mul + "mul(#{first},#{second})".length
    end
    segment = segment[start_pos..-1]
  end

  total
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
