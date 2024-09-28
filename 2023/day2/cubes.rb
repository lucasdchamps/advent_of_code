class Set
  attr_reader :red, :blue, :green

  def initialize(set)
    set.split(", ").each do |line|
      digit = line.split(" ")[0].to_i
      color = line.split(" ")[1]
      @blue = digit if color == "blue"
      @green = digit if color == "green"
      @red = digit if color == "red"
    end
  end

  def possible?
    return false if @red and @red > 12
    return false if @green and @green > 13
    return false if @blue and @blue > 14
    return true
  end
end

class Game
  def initialize(line)
    @sets = line.strip.split(": ")[1].split("; ").map { |set| Set.new(set) }
  end

  def possible?
    return @sets.all? { |set| set.possible? }
  end

  def powers
    return @sets.map(&:red).compact.max * @sets.map(&:blue).compact.max * @sets.map(&:green).compact.max
  end
end

result1 = 0
result2 = 0
File.foreach("games.txt").with_index do |game, index|
  result1 += index + 1 if Game.new(game).possible?
  result2 += Game.new(game).powers
end
puts result1
puts result2