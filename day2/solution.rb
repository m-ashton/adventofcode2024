def get_reports_from_file(filename)
  File.readlines(filename).map(&:split).map { |report| report.map(&:to_i) }
end

def differences(report)
  report.each_cons(2).map { |pair| pair[0] - pair[1] }
end

def safe?(differences)
  sign_test = if differences[0].negative?
    :negative?
  else
    :positive?
  end
  differences.all? { |diff| diff.send(sign_test) && diff.abs >= 1 && diff.abs <= 3 }
end

def part1
  reports = get_reports_from_file('./input.txt')
  safe_reports = reports.filter { |report| safe?(differences(report)) }
  puts safe_reports.count
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

  safe_reports = candidate_reports.filter do |candidates|
    candidates.any? do |report|
      safe?(differences(report))
    end
  end

  puts safe_reports.count
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
