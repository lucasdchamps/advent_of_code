class Hand
    include Comparable
    
    attr_reader :hand, :bid, :kind

    @@label_values = { "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "T" => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14 }
    @@kind_values = { high_card: 1, one_pair: 2, two_pair: 3, three_of_a_kind: 4, full_house: 5, four_of_a_kind: 6, five_of_a_kind: 7 }

    def initialize(hand, bid)
      @hand = hand
      @bid = bid
      @kind = compute_kind
    end

    def <=>(other)
      return compare_labels(other) if kind == other.kind
      return @@kind_values[@kind] <=> @@kind_values[other.kind]
    end

    private
    def compute_kind
      groups = @hand.chars.group_by { |c| c }
      return :five_of_a_kind if groups.keys.size === 1
      if groups.keys.size == 2
        return :four_of_a_kind if groups.values.find { |val| val.size == 4 }
        return :full_house if groups.values.find { |val| val.size == 3 }
      end
      if groups.keys.size == 3
        return :three_of_a_kind if groups.values.find { |val| val.size == 3 }
        return :two_pair if groups.values.find { |val| val.size == 2 }
      end
      return :one_pair if groups.keys.size == 4
      return :high_card
    end

    def compare_labels(other)
      @hand.chars.each.with_index do |char, idx|
        other_char = other.hand.chars[idx]
        next if char == other_char
        return @@label_values[char] <=> @@label_values[other_char]
      end
    end
end

class JokerHand < Hand
  @@label_values = { "J" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "T" => 10, "Q" => 12, "K" => 13, "A" => 14 }

  private
  def compute_kind
    groups = @hand.chars.group_by { |c| c }
    return :five_of_a_kind if groups.keys.size === 1
    if groups.keys.size == 2
      if groups.values.find { |val| val.size == 4 }
        return :five_of_a_kind if groups["J"]
        return :four_of_a_kind
      end
      if groups.values.find { |val| val.size == 3 }
        return :five_of_a_kind if groups["J"]
        return :full_house
      end
    end
    if groups.keys.size == 3
      if groups.values.find { |val| val.size == 3 }
        return :four_of_a_kind if groups["J"]
        return :three_of_a_kind
      end
      if groups.values.find { |val| val.size == 2 }
        return :four_of_a_kind if groups["J"] and groups["J"].size == 2
        return :full_house if groups["J"] and groups["J"].size == 1
        return :two_pair
      end
    end
    if groups.keys.size == 4
      return :three_of_a_kind if groups["J"]
      return :one_pair
    end
    return :one_pair if groups["J"]
    return :high_card
  end
end

$lines = File.foreach("#{File.dirname(__FILE__)}./hands_and_bids.txt").map { |line| line.chomp }

def part1
  $lines.map { |line| Hand.new(line.split(" ")[0], line.split(" ")[1].to_i) }.sort.map.with_index { |h, i| h.bid * (i + 1) }.reduce(:+)
end

p part1

def part2
  $lines.map { |line| JokerHand.new(line.split(" ")[0], line.split(" ")[1].to_i) }.sort.map.with_index { |h, i| h.bid * (i + 1) }.reduce(:+)
end

p part2
