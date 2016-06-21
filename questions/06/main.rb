require 'benchmark'
require 'pry'

module Q06
  COUNT = 10000

  module_function

  def repeatable? i, start
    if i == start
      true
    elsif i == 1
      false
    else
      if i.even?
        repeatable? i / 2, start
      else
        repeatable? i * 3 + 1, start
      end
    end
  end

  def run
    (2..COUNT).step(2).count do |i|
      repeatable?(i * 3 + 1, i)
    end
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q06.run
  end
end

puts
puts "answer : #{$answer}"
