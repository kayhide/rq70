require 'benchmark'
require 'pry'

module Q13
  module_function

  LEFT = %w(READ WRITE TALK)
  RIGHT = 'SKILL'

  def run
    results = []
    chars = [*LEFT, RIGHT].inject(:+).each_char.to_a.uniq
    (0..9).to_a.permutation(chars.length).each do |nums|
      map = chars.zip(nums).to_h
      if [*LEFT, RIGHT].none? { |word| map[word[0]] == 0 }
        left = LEFT.map { |str| str.gsub(/./) { |s| map[s] }.to_i }
        right = RIGHT.gsub(/./) { |s| map[s] }.to_i
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
