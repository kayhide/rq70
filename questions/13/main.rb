require 'benchmark'
require 'pry'

module Q13
  module_function

  LEFT = %w(READ WRITE TALK)
  RIGHT = 'SKILL'

  def to_num str, map
    @codepoints[str].inject(0) { |memo, c| memo * 10 + map[c] }
  end

  def numbers words
    @codepoints = words.map { |str| [str, str.codepoints] }.to_h

    results = []
    chars = @codepoints.values.flatten.uniq
    heads = @codepoints.values.map(&:first).uniq
    tails = chars - heads
    (1..9).to_a.permutation(heads.length).each do |xs|
      ((0..9).to_a - xs).permutation(tails.length).each do |ys|
        map = (heads + tails).zip(xs + ys).to_h
        nums = words.map { |str| to_num(str, map) }
        results << nums if yield(nums)
      end
    end
    [results.length, *results]
  end

  def run
    numbers([*LEFT, RIGHT]) { |nums| nums[0..-2].inject(:+) == nums[-1] }
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q13.run
  end
end

puts
puts "answer : #{$answer}"
