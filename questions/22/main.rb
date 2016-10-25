require 'benchmark'
require 'pry'

module Q22
  module_function

  COUNT = 16

  def cache
    @cache ||= [1, 0]
  end

  def patterns count
    cache[count] ||= 0.step(count - 2, 2).map do |i|
      patterns(i) * patterns(count - 2 - i)
    end.inject(:+)
  end

  def run
    patterns COUNT
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q22.run
  end
end

puts
puts "answer : #{$answer}"
