universe = File.foreach("#{File.dirname(__FILE__)}./universe.txt").map { |line| line.chomp.split("") }
$rows_to_expand = Set.new(universe.map.with_index { |row, x| x if row.all? { |c| c == "." } }.compact)
$cols_to_expand = Set.new(0.upto(universe[0].size - 1).map { |y| y if 0.upto(universe.size - 1).all? { |x| universe[x][y] == "." } }.compact)
$galaxies = []
universe.each.with_index { |r, x| r.each.with_index { |c, y| $galaxies << [x,y] if c == "#" } }

def sum_distances(expansion)
  total = 0
  $galaxies.each.with_index do |g1, i|
    $galaxies[i+1..].each do |g2|
      (xstart, xend) = [g1[0], g2[0]].minmax
      (ystart, yend) = [g1[1], g2[1]].minmax
      total += xend - xstart + yend - ystart
      xstart.upto(xend) { |x| total += (expansion - 1) if $rows_to_expand.include?(x) }
      ystart.upto(yend) { |y| total += (expansion - 1) if $cols_to_expand.include?(y) }
    end
  end
  total
end

p sum_distances(2)
p sum_distances(1000000)
