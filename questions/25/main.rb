require 'benchmark'
require 'pry'

module Q25
  module_function

  COUNT = 6

  def patterns
    ns = (1..(COUNT-1)).to_a.permutation.to_a
    ns.product(ns).map do |xs, ys|
      xs = [0, *xs.zip(xs).inject(:+)]
      ys = [*ys.zip(ys).inject(:+), 0]
      xs.zip ys
    end
  end

  def count_crossings pattern
    pattern.combination(2).count { |x, y| crossing? x, y }
  end

  def crossing? x, y
    (x.first - y.first) * (x.last - y.last) < 0
  end

  def run
    xs = patterns.map { |p| [count_crossings(p), p] }
    x = xs.max_by(&:first)
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q25.run
  end
end

puts
puts "answer : #{$answer}"
