require 'benchmark'

module Q17
  COUNT = 30

  module_function

  def patterns queue
    if queue.count == COUNT
      [queue]
    elsif queue.last == :female
      patterns([*queue, :mail])
    else
      patterns([*queue, :mail]) + patterns([*queue, :female])
    end
  end

  def count queue
    if queue.count == COUNT
      1
    elsif queue.last == :female
      count([*queue, :mail])
    else
      count([*queue, :mail]) + count([*queue, :female])
    end
  end

  def solve boy, girl, left
    if left == 0
      boy + girl
    else
      solve boy + girl, boy, left - 1
    end
  end

  def run
    # patterns([]).count
    # count []
    solve 1, 1, COUNT - 1
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q17.run
  end
end

puts
puts "answer : #{$answer}"
