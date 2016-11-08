require 'benchmark'
require 'pry'

module Q23
  module_function

  COINS = 10
  COUNT = 24

  def cache
    @cache ||= {}
  end

  def count_patterns n, coins
    cache[[n, coins]] ||=
      if coins > 0
        if n == 0
          1
        else
          count_patterns(n - 1, coins + 1) + count_patterns(n - 1, coins - 1)
        end
      else
        0
      end
  end

  def run
    count_patterns COUNT, COINS
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q23.run
  end
end

puts
puts "answer : #{$answer}"
