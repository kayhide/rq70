require 'pry'
require 'benchmark'

module Q12
  module_function

  NUMS = ('0'..'9').to_a

  def squares
    i = 0
    Enumerator.new do |y|
      loop do
        i += 1
        y << [i, Math.sqrt(i)]
      end
    end.lazy
  end

  def match_with_integral? f
    f.to_s.sub('.', '').each_char.take(10).sort == NUMS
  end

  def match_without_integral? f
    f.to_s.sub(/.*\./, '').each_char.take(10).sort == NUMS
  end

  def run
    [
      squares.drop_while { |i, f| !match_with_integral?(f) }.first,
      squares.drop_while { |i, f| !match_without_integral?(f) }.first
    ]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q12.run
  end
end

puts
puts "answer : #{$answer}"
