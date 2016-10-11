require 'benchmark'
require 'pry'

module Q20
  module_function

  NUMBERS = [1, 14, 14, 4, 11, 7, 6, 9, 8, 10, 10, 5, 13, 2, 3, 15]

  def combinations nums
    if nums.empty?
      [[]]
    else
      combinations(nums.drop(1)).map { |ns| [[nums.first, *ns], ns] }.inject(:+)
    end
  end

  def run_
    sum, nss = combinations(NUMBERS)
                 .group_by { |ns| ns.inject(:+) }
                 .max_by { |sum, nss| nss.count }
    [sum, nss.count]
  end

  def dynamic_count counts, nums
    if nums.empty?
      counts
    else
      n = nums.first
      dynamic_count (Array.new(n, 0) + counts).zip(counts).map { |x, y| x + y.to_i },
                    nums.drop(1)
    end
  end

  def run
    count, sum = dynamic_count([1], NUMBERS).each_with_index.max_by(&:first)
    [sum, count]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q20.run
  end
end

puts
puts "answer : #{$answer}"
