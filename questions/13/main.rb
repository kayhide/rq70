require 'benchmark'
require 'pry'

module Q13
  module_function

  LEFT = %w(READ WRITE TALK)
  RIGHT = 'SKILL'

  def to_num str, map
    str.each_char.inject(0) { |memo, c| memo * 10 + map[c] }
  end

  def run
    results = []
    chars = [*LEFT, RIGHT].inject(:+).each_char.to_a.uniq
    heads = [*LEFT, RIGHT].map { |str| str[0] }
    tails = chars - heads
    (1..9).to_a.permutation(heads.length).each do |xs|
      ((0..9).to_a - xs).permutation(tails.length).each do |ys|
        map = (heads.zip(xs) + tails.zip(ys)).to_h
        left = LEFT.map { |str| to_num(str, map) }
        right = to_num(RIGHT, map)
        results << [*left, right] if left.inject(:+) == right
      end
    end
    [results.length, *results]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q13.run
  end
end

puts
puts "answer : #{$answer}"
