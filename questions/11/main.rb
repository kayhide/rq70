require 'benchmark'
require 'pry'

module Q11
  module_function

  def fib n
    @fibs ||= []
    @fibs[n] ||=
      if n < 2
        1
      else
        fib(n - 2) + fib(n - 1)
      end
  end

  def dividable? n
    i = n
    sum = 0
    while i > 0
      sum += i % 10
      i = i / 10
    end
    # puts "n: #{n}, sum: #{sum}"
    n % sum == 0
  end

  def run
    enum = Enumerator.new do |y|
      i = 0
      loop do
        n = fib(i)
        y << n if dividable?(n)
        i += 1
      end
    end
    enum.lazy.drop(8).take(5).to_a
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q11.run
  end
end

puts
puts "answer : #{$answer}"
