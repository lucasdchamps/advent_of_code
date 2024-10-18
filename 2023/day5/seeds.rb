def build_range(start, length)
  (start..(start + length - 1))
end

class MapRange
  def initialize(range)
    length = range.split(" ")[2].to_i
    @dest = build_range(range.split(" ")[0].to_i, length)
    @source = build_range(range.split(" ")[1].to_i, length)
  end

  def contains?(seed)
    @source.cover?(seed)
  end

  def apply(seed)
    seed + (@dest.first - @source.first)
  end

  def overlaps?(seed)
    @source.first <= seed.last and seed.first <= @source.last
  end
  
  def split_non_overlapping(seed)
    non_overlapping_ranges = []
    non_overlapping_ranges << build_range(seed.first, @source.first - seed.first) if seed.first < @source.first
    non_overlapping_ranges << build_range(@source.last + 1, seed.last - @source.last) if @source.last < seed.last
    non_overlapping_ranges
  end

  def apply_range(seed)
    return build_range(@dest.first, [seed.last, @source.last].min + 1 - @source.first) if seed.first < @source.first
    build_range(@dest.first + (seed.first - @source.first), [seed.last, @source.last].min + 1 - seed.first)
  end
end

class Map
  def initialize(ranges)
    @ranges = ranges.map { |range| MapRange.new(range) }
  end

  def apply(seed)
    @ranges.each { |range| return range.apply(seed) if range.contains?(seed) }
    seed
  end

  def apply_range(seed)
    mapped = []
    non_mapped = [seed]
    @ranges.each do |range|
      non_mapped = non_mapped.map do |non_mapped|
        if range.overlaps?(non_mapped)
          mapped << range.apply_range(non_mapped)
          range.split_non_overlapping(non_mapped)
        else
          non_mapped
        end
      end.flatten
    end
    mapped + non_mapped
  end
end

lines = File.foreach("#{File.dirname(__FILE__)}./maps.txt").map { |l| l }
$seeds = lines[0].chomp.split(" ")[1..].map(&:to_i)
$maps = lines[2..].join("").split(/^$/).map do |map_text|
  Map.new(map_text.split("\n").select { |line| not line.include?("map") })
end

def part1
  min_loc = Float::INFINITY
  $seeds.each do |seed|
    loc = seed
    $maps.each { |map| loc = map.apply(loc) }
    min_loc = loc if loc < min_loc
  end
  min_loc
end
p part1

$seeds = lines[0].split(" ")[1..].each_slice(2).map { |pair| build_range(pair[0].to_i, pair[1].to_i) }

def part2
  min_loc = Float::INFINITY
  $seeds.each do |seed|
    locs = [seed]
    $maps.each { |map| locs = locs.map { |r| map.apply_range(r) }.flatten }
    min = locs.map(&:first).min
    min_loc = min if min < min_loc
  end
  min_loc
end
p part2
