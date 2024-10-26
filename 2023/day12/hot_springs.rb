lines = File.foreach("#{File.dirname(__FILE__)}./condition_records.txt").map { |line| line.chomp }
springs = lines.map { |l| l.split(" ")[0] }
records = lines.map { |l| l.split(" ")[1].split(",").map(&:to_i) }
$cache = {}

def arrangements(spring, record)
  spring = spring[1..] while spring[0] == "."
  
  cache_key = spring + record.join(",")
  return $cache[cache_key] if $cache[cache_key]

  return spring.include?("#") ? 0 : 1 if record.length == 0
  return 0 if spring.size < record.reduce(:+) + record.size - 1
  
  size = record[0]
  return spring.include?(".") ? 0 : 1 if spring.size == size

  arrangements = 0
  arrangements += arrangements(spring[1..], record) if spring[0] == "?"
  arrangements += arrangements(spring[size + 1..], record[1..]) if not spring[0..size - 1].include?(".") and spring[size] != "#"
  $cache[cache_key] = arrangements
  return arrangements
end

p springs.map.with_index { |spring, i| arrangements(spring, records[i]) }.reduce(:+)
p springs.map.with_index { |spring, i| arrangements((spring + "?") * 4 + spring, records[i] * 5) }.reduce(:+)