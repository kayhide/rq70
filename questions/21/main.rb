require 'benchmark'
require 'pry'

class Array
  def to_next_row
    [false, *self].zip([*self, false]).map { |pair| pair.inject(:^) }
  end
end

module Q21
  module_function

  TARGET = 2014
  # TARGET = 4

  def solve count, rows
    next_row = rows.last.to_next_row
    next_count = count - next_row.count(false)
    if next_count <= 0
      [*rows, next_row]
    else
      solve next_count, [*rows, next_row]
    end
  end

  def run
    res = solve TARGET, [[true]]
    res.count
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q21.run
  end
end

puts
puts "answer : #{$answer}"
