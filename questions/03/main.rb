require 'benchmark'
require 'pry'

class Array
  def to_bits
    each_with_index.inject(0) { |memo, pair| pair.first ? memo | (1 << pair.last) : memo }
  end
end

class Integer
  def to_bools
    ary = []
    i = self
    while i > 0
      ary << (i & 1 == 1)
      i >>= 1
    end
    ary
  end
end

module Q03
  COUNT = 100

  module_function

  def format cards
    cards.each_with_index.reject(&:first).map(&:last).map { |i| i + 1 }
  end

  def run_
    cards = COUNT.times.map { |i| false }.to_bits
    COUNT.times do |i|
      start = i + 1
      step = i + 2
      bits = (start..COUNT).step(step).to_a.to_bits

      cards ^= bits
    end
    binding.pry

    format cards.to_bools
  end

  def run
    cards = COUNT.times.map { |i| false }
    COUNT.times do |i|
      start = i + 1
      step = i + 2
      (start..COUNT).step(step).each do |j|
        cards[j] = !cards[j]
      end
    end
    format cards
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q03.run
  end
end

puts
puts "answer : #{$answer}"


# true true => false
# false true => true
# true false => true
# false false => false
