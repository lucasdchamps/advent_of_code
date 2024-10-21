$histories = File.foreach("#{File.dirname(__FILE__)}./history.txt").map { |line| line.chomp.split(" ").map(&:to_i) }

def reduce(history)
  reduces = [history]
  reduce = history
  while not reduce.all? { |r| r == 0 }
    reduce = reduce.each_cons(2).map { |p| p[1] - p[0] }
    reduces << reduce
  end
  reduces 
end

def part1
  $histories.map do |h|
    reduce(h).reverse.reduce(0) { |sum, r| sum + r[-1] }
  end.reduce(:+)
end
p part1

def part2
  $histories.map do |h|
    reduce(h).reverse.reduce(0) { |sum, r| r[0] - sum }
  end.reduce(:+)
end
p part2
