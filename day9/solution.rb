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

def initialize_disk_part_2(filename)
  disk = []
  metadata = {files: {}, free_space: {}}
  disk_map = File.open(filename).read.strip.chars.map(&:to_i)
  disk_pos = 0
  disk_map.each.with_index do |value, i|
    if i.even? # file
      id = i / 2
      value.times do
        disk << id
      end
      metadata[:files][id] = {start: disk_pos, size: value, compacted: false}
      disk_pos += value
    elsif value > 0 # free space
      value.times do
        disk << nil
      end
      metadata[:free_space][disk_pos] = {size: value}
      disk_pos += value
    end
  end
  
  [disk, metadata]
end

def move_file(disk, metadata, id:, to:)
  return unless id && to
  
  file_metadata = metadata[:files][id]
  
  (to...to + file_metadata[:size]).each do |pos|
    disk[pos] = id
  end
  
  (file_metadata[:start]...file_metadata[:start] + file_metadata[:size]).each do |pos|
    disk[pos] = nil
  end
  
  file_metadata[:start] = to
  file_metadata[:compacted] = true
  
  space_metadata = metadata[:free_space].delete(to)
  if file_metadata[:size] < space_metadata[:size]
    metadata[:free_space][to + file_metadata[:size]] = {size: space_metadata[:size] - file_metadata[:size]}
    return to + file_metadata[:size]
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
  disk, metadata = initialize_disk_part_2('./input.txt')
  
  metadata[:files].reject { |k, v| v[:compacted] }.keys.sort.reverse.each do |file_id|
    # puts '---------'
    # puts disk.inspect
    # puts metadata.inspect
    # puts '---------'
    free_positions = metadata[:free_space].keys.sort
    free_positions.each do |position|
      if metadata[:files][file_id][:size] <= metadata[:free_space][position][:size]
        move_file(disk, metadata, id: file_id, to: position)
        break
      end
    end
  end
  disk.map.with_index { |id, i| id.nil? ? 0 : id * i }.sum
end

ARGV[0] == '2' ? puts(part2) : puts(part1.inspect)
