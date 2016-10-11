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

  def run
    sum, nss = combinations(NUMBERS)
                 .group_by { |ns| ns.inject(:+) }
                 .max_by { |sum, nss| nss.count }
    [sum, nss.count]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q20.run
  end
end

puts
puts "answer : #{$answer}"
