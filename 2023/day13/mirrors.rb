lines = File.foreach("#{File.dirname(__FILE__)}./patterns.txt").map { |line| line.chomp }
patterns = []
pattern = []
lines.each do |line|
  if line == ""
    patterns << pattern
    pattern = []
  else
    pattern << line.split("")
  end
end
patterns << pattern

def matches?(row1, row2)
  row1.join("") == row2.join("")
end

def mirror?(pattern, i)
  idx1 = i - 1
  idx2 = i + 2
  while 0 <= idx1 and idx2 <= pattern.size - 1
    return false unless matches?(pattern[idx1], pattern[idx2])
    idx1 -= 1
    idx2 += 1
  end
  true
end

def find_row_reflections(pattern)
  pattern.each_cons(2).map.with_index do |pair, i|
    next unless matches?(pair[0], pair[1])
    next unless mirror?(pattern, i)
    (i + 1) * 100
  end.compact
end

def find_col_reflections(pattern)
  cols = Array.new(pattern[0].size) { Array.new }
  pattern.each { |row| cols.each.with_index { |c, i| c << row[i] } }
  return find_row_reflections(cols).map { |r| r / 100 }
end

def find_reflections(pattern)
  return find_row_reflections(pattern) + find_col_reflections(pattern)
end

def find_reflection_with_smug(pattern)
  old_reflection = find_reflections(pattern).max
  pattern.each.with_index do |row, x|
    row.each.with_index do |cell, y|
      pattern[x][y] = cell == "#" ? "." : "#"
      reflections = find_reflections(pattern)
      new_reflection = reflections.find { |r| r != old_reflection }
      return new_reflection if new_reflection and new_reflection > 0
      pattern[x][y] = cell
    end
  end
end

p patterns.map { |p| find_reflections(p).max }.reduce(:+)
p patterns.map { |p| find_reflection_with_smug(p) }.reduce(:+)