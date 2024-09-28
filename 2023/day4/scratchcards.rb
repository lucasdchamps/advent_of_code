class Card
  attr_reader :matching_numbers
  
  def initialize(line)
    numbers = line.strip.split(":")[1]
    @winning_numbers = Set.new(numbers.split("|")[0].split(" ").map { |chars| chars.strip.to_i })
    @numbers = numbers.split("|")[1].split(" ").map { |chars| chars.strip.to_i }
    @matching_numbers = @numbers.select { |number| @winning_numbers.include?(number) }
  end

  def worth
    return 0 if @matching_numbers.size == 0
    return 2 ** (@matching_numbers.size - 1)
  end
end

class Cards
  def initialize
    @cards = []
    File.foreach("scratchcards.txt") do |line|
      @cards.push(Card.new(line))
    end
  end

  def sum_worths
    @cards.map(&:worth).reduce(:+)
  end

  def sum_copies
    list_copies.reduce(:+)
  end

  private

  def list_copies
    copies = Array.new(@cards.size, 1)
    @cards.each.with_index do |card, idx|
      matching_numbers = card.matching_numbers
      next if matching_numbers.size == 0
      1.upto(matching_numbers.size) do |shift|
        break if idx + shift >= copies.size
        copies[idx + shift] += copies[idx]
      end
    end
    copies
  end
end

p Cards.new.sum_worths
p Cards.new.sum_copies
