class Node
  attr_reader :x, :y
  attr_accessor :label, :in_loop
  
  def initialize(label, coords)
    @label = label
    (@x, @y) = coords
    @in_loop = (label == "S")
  end
end

$grid = []
$start = nil
lines = File.foreach("#{File.dirname(__FILE__)}./maze.txt").map { |line| line.chomp.split("") }
lines.each.with_index { |line, x| $grid << line.map.with_index { |cell, y| Node.new(cell, [x, y]) } }

def connections(node)
  connections = []
  connections = [[node.x-1, node.y], [node.x+1, node.y]] if node.label == "|"
  connections = [[node.x, node.y+1], [node.x, node.y-1]] if node.label == "-"
  connections = [[node.x-1, node.y], [node.x, node.y+1]] if node.label == "L"
  connections = [[node.x-1, node.y], [node.x, node.y-1]] if node.label == "J"
  connections = [[node.x+1, node.y], [node.x, node.y-1]] if node.label == "7"
  connections = [[node.x, node.y+1], [node.x+1, node.y]] if node.label == "F"
  connections.map { |c| $grid[c[0]][c[1]] if $grid[c[0]] }.compact
end

def part1
  distance = 0
  currents = []
  $grid.each { |row| row.each { |cell| currents << cell if connections(cell).find { |c| c.label == "S" } } }
  while currents.size > 0
    currents.each { |c| c.in_loop = true }
    currents = currents.map { |c| connections(c).find { |n| not n.in_loop } }.compact
    distance += 1
  end
  distance
end
p part1

def in_grid?(node)
  return false unless node.label == "."
  wall_count = 0
  prev = nil
  (node.x - 1).downto(0) do |x|
    label = $grid[x][node.y].label
    wall_count += 1 if label == "-"
    prev = label if label == "L" or label == "J"
    wall_count += 1 if (label == "7" and prev == "L") or (label == "F" and prev == "J")
  end
  wall_count % 2 == 1
end

def part2 
  $grid.each { |row| row.each { |node| node.label = "." if node.label != "." and not node.in_loop } }
  $grid.map { |row| row.count { |node| in_grid?(node) } }.reduce(:+)
end
p part2
