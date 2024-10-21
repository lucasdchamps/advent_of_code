class Node
  attr_reader :label, :right, :left, :is_ending

  def initialize(label)
    @label = label
    @is_ending = @label[-1] == "Z"
  end

  def connect(left, right)
    @left = left
    @right = right
  end
end

lines = File.foreach("#{File.dirname(__FILE__)}./instructions.txt").map { |line| line.chomp }
$moves = lines[0]
$nodes = {}
lines[2..].each do |line|
  label = line.split(" = ")[0]
  $nodes[label] = Node.new(label)
  neighbours = line.scan(/\(([1-9A-Z]{3}), ([1-9A-Z]{3})\)/)[0]
  $nodes[label].connect(neighbours[0], neighbours[1])
end

def move(node, move)
   return (move == "L" ? $nodes[node.left] : $nodes[node.right])
end

def part1
  nb_moves = 0
  move_idx = 0
  node = $nodes["AAA"]
  while node.label != "ZZZ"
    nb_moves += 1
    node = move(node, $moves[move_idx])
    move_idx = (move_idx + 1) % $moves.size
  end
  nb_moves
end
p part1

def part2
  nb_moves = 0
  move_idx = 0
  nodes = $nodes.keys.select { |k| k[-1] == "A" }.map { |l| $nodes[l] }
  cycles = Array.new(nodes.size, 0)
  while cycles.any? { |c| c == 0 }
    nb_moves += 1
    nodes = nodes.map { |n| move(n, $moves[move_idx]) }
    nodes.each.with_index { |n, i| cycles[i] = nb_moves if cycles[i] == 0 and n.is_ending }
    move_idx = (move_idx + 1) % $moves.size
  end
  $moves.size * cycles.map { |c| c / $moves.size }.reduce(:*)
end
p part2
