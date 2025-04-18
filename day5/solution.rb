def get_input(filename)
  rule_segment, update_segment = File.open(filename).read.split("\n\n")

  rule_values = rule_segment.split("\n").map { |rule| rule.split('|') }
  ordering_rules = Hash.new { |hash, key| hash[key] = Array.new }
  rule_values.each do |prior_page, subsequent_page|
    ordering_rules[prior_page] << subsequent_page
  end

  updates = update_segment.split("\n").map { |line| line.split(',') }

  [ordering_rules, updates]
end

def part1
  ordering_rules, updates = get_input('input.txt')

  valid_updates = updates.select do |update|
    update.each_cons(2).all? do |prior_page, subsequent_page|
      ordering_rules[prior_page].nil? || ordering_rules[prior_page].include?(subsequent_page)
    end
  end

  valid_updates.map do |update|
    update[(update.length / 2)].to_i # the middle page
  end.sum
end

def part2
  ordering_rules, updates = get_input('input.txt')

  invalid_updates = updates.select do |update|
    update.each_cons(2).any? do |prior_page, subsequent_page|
      !ordering_rules[prior_page].nil? && !ordering_rules[prior_page].include?(subsequent_page)
    end
  end

  invalid_updates.sum do |update|
    update.sort! do |a, b|
      if ordering_rules[a].nil?
        0
      elsif ordering_rules[a].include?(b)
        -1
      else
        1
      end
    end
    update[(update.length / 2)].to_i # the middle page
  end
end

ARGV[0] == '2' ? puts(part2) : puts(part1)
