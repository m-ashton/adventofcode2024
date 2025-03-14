def get_reports_from_file(filename)
  File.readlines(filename).map(&:split).map { |report| report.map(&:to_i) }
end

def differences(report)
  report.each_cons(2).map { |pair| pair[0] - pair[1] }
end

def safe?(differences)
  if differences[0] < 0
    return false if differences.any? { |diff| diff > 0 }
  else
    return false if differences.any? { |diff| diff < 0 }
  end
  differences.all? { |diff| diff.abs >= 1 && diff.abs <= 3 }
end

def part1
  reports = get_reports_from_file('./input.txt')
  puts reports.filter { |report| safe?(differences(report)) }.count
end

def part2
  reports = get_reports_from_file('./input.txt')
  candidate_reports = reports.map do |report|
    (0..report.size - 1).reduce([]) do |acc, i|
      candidate_report = report.dup
      candidate_report.delete_at(i)
      acc << candidate_report
    end
  end
  puts(candidate_reports.filter do |candidates|
    candidates.any? do |report|
      safe?(differences(report))
    end
  end.count)
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
