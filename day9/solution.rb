def initialize_disk(filename)
  [].tap do |disk|
    disk_map = File.open(filename).read.strip.chars.map(&:to_i)
    disk_map.each.with_index do |value, i|
      if i.even? # file
        value.times do
          disk << i / 2
        end
      else # free space
        value.times do
          disk << nil
        end
      end
    end
  end
end

def part1
  disk = initialize_disk('./input.txt')
  last_file_block_pos = disk.length - 1
  last_file_block_pos -= 1 while disk[last_file_block_pos].nil?

  (1...disk.size).each do |i|
    break if i == last_file_block_pos
    if disk[i].nil?
      disk[i] = disk[last_file_block_pos]
      disk[last_file_block_pos] = nil
      last_file_block_pos -= 1 while disk[last_file_block_pos].nil?
    end
  end
  disk.map.with_index { |id, i| id.nil? ? 0 : id * i }.sum
end

def part2
  disk = initialize_disk('./input.txt')
  # puts disk.inspect

  disk.uniq.compact.reverse.each do |file_id|
    free_space_cursor = 0
    file_size = 0
    file_start = disk.find_index(file_id)

    file_size += 1 until (disk[file_start + file_size] != file_id)

    while free_space_cursor < file_start
      free_space_cursor += 1 until disk[free_space_cursor].nil?
      free_space_end = free_space_cursor

      while free_space_end < disk.size && disk[free_space_end].nil?
        free_space_end += 1
      end

      free_space_size = free_space_end - free_space_cursor
      if file_size <= free_space_size
        (free_space_cursor...free_space_cursor + file_size).each do |pos|
          disk[pos] = file_id
        end
        (file_start...file_start + file_size).each do |pos|
          disk[pos] = nil
        end
        break
      end
      free_space_cursor = free_space_end
    end
    # puts disk.inspect
  end
  disk.map.with_index { |id, i| id.nil? ? 0 : id * i }.sum
end

ARGV[0] == '2' ? puts(part2) : puts(part1.inspect)
