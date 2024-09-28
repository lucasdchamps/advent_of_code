def parse_calibration(line)
  digits = line.split("").select { |char| char.match?(/[[:digit:]]/) }.map { |char| char.to_i }
  digits[0] * 10 + digits[digits.size - 1]
end

calibration = 0
File.foreach("calibration.txt") do |line|
  calibration += parse_calibration(line)
end
puts calibration

def parse_digit(line)
  return line[0].to_i if line[0].match?(/[[:digit:]]/)

	digit_hash = { one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 }
	(2..4).each do |l|
		chars = line[0..l].to_sym
		return digit_hash[chars] if digit_hash.key?(chars)
	end

	nil
end

def parse_calibration2(line)
	digits = line.each_char.map.with_index do |char, index|
		parse_digit(line[index..])
	end
	digits.compact!
	
	digits[0] * 10 + digits[digits.size - 1]
end

calibration = 0
File.foreach("calibration.txt") do |line|
  calibration += parse_calibration2(line)
end
puts calibration