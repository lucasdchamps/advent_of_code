lines = File.foreach("#{File.dirname(__FILE__)}./times_and_distances.txt").map { |line| line.chomp }
$times = lines[0].split(" ")[1..].map(&:to_i)
$distances = lines[1].split(" ")[1..].map(&:to_i)

def part1
  $times.map.with_index do |time, i|
    1.upto(time - 1).count { |remaining| $distances[i] < (time - remaining) * remaining }
  end.reduce(:*)
end
p part1

$time = lines[0].split(" ")[1..].join("").to_i
$distance = lines[1].split(" ")[1..].join("").to_i

def part2
  1.upto($time - 1).count { |holding| $distance < ($time - holding) * holding }
end
p part2