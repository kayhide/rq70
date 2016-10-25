require 'benchmark'
require 'pry'

module Q00
  module_function

  def run
    'answer'
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q00.run
  end
end

puts
puts "answer : #{$answer}"
