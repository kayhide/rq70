require 'prime'
require 'benchmark'
require 'pry'

class Array
  def to_pairs
    [
      [first, first],
      *each_cons(2),
      [last, last]
    ]
  end

  def to_composite_nums
    to_pairs.map { |x, y| x * y }
  end
end

module Q19
  module_function

  def run
    nums = Prime.take(6)
           .permutation.to_a
           .map(&:to_composite_nums)
           .min_by(&:max)
    [nums.max, nums]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q19.run
  end
end

puts
puts "answer : #{$answer}"
