def is_symbol?(char)
  return false if char.match?(/[[:digit:]]/)
  return char != "."
end

class Engine
  def initialize
    @engine = []
    File.foreach("engine.txt") do |line|
      @engine.push(line.strip.split(""))
    end
  end

  def sum_part_numbers
    sum = 0
    @visited = Set.new
    @engine.each.with_index do |row, row_index|
      row.each.with_index do |char, col_index|
        next unless is_symbol?(char)
        sum += find_part_numbers(row_index, col_index).reduce(:+)
      end
    end
    sum
  end

  def sum_gear_ratios
    sum = 0
    @visited = Set.new
    @engine.each.with_index do |row, row_index|
      row.each.with_index do |char, col_index|
        next unless char == "*"
        part_numbers = find_part_numbers(row_index, col_index).filter { |num| num > 0 }
        sum += part_numbers.reduce(:*) if part_numbers.size == 2
      end
    end
    sum
  end

  private

  def find_part_numbers(row_index, col_index)
    part_numbers = [0]
    part_numbers.push(find_part_number(row_index - 1, col_index - 1))
    part_numbers.push(find_part_number(row_index - 1, col_index))
    part_numbers.push(find_part_number(row_index - 1, col_index + 1))
    part_numbers.push(find_part_number(row_index, col_index - 1))
    part_numbers.push(find_part_number(row_index, col_index + 1))
    part_numbers.push(find_part_number(row_index + 1, col_index - 1))
    part_numbers.push(find_part_number(row_index + 1, col_index))
    part_numbers.push(find_part_number(row_index + 1, col_index + 1))
    part_numbers
  end

  def find_part_number(row_index, col_index)
    return 0 unless is_new_number?(row_index, col_index)
    return build_number(row_index, col_index)
  end

  def is_new_number?(row_index, col_index)
    return false if row_index < 0
    return false if row_index > @engine.size - 1
    return false if col_index < 0
    return false if col_index > @engine[0].size - 1
    return false if @visited.include?([row_index, col_index])
    return @engine[row_index][col_index].match?(/[[:digit:]]/)
  end

  def build_number(row_index, col_index)
    @visited.add([row_index, col_index])
    number = [@engine[row_index][col_index]]

    idx = col_index - 1
    symbol = @engine[row_index][idx]
    while symbol and symbol.match?(/[[:digit:]]/)
      @visited.add([row_index, idx])
      number.unshift(symbol)
      idx -= 1
      symbol = @engine[row_index][idx]
    end

    idx = col_index + 1
    symbol = @engine[row_index][idx]
    while symbol and symbol.match?(/[[:digit:]]/)
      @visited.add([row_index, idx])
      number.push(symbol)
      idx += 1
      symbol = @engine[row_index][idx]
    end

    number.join("").to_i
  end
end

p Engine.new.sum_part_numbers
p Engine.new.sum_gear_ratios