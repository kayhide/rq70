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

  def run
    patterns([]).count
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q17.run
  end
end

puts
puts "answer : #{$answer}"
