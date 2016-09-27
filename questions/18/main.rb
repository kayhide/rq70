require 'benchmark'
require 'pry'
require 'set'

$>.sync = true
# module Q18
#   module_function

#   class Piece < Struct.new :berry_count
#   end

#   class Whole < Struct.new :pieces
#     def self.squared_nums
#       @squared_nums ||= Set.new [1]
#     end

#     def self.prepare_squared_nums n
#       ((Math.sqrt(squared_nums.max).floor + 1)..Math.sqrt(n).ceil).each do |i|
#         squared_nums << (i * i)
#       end
#     end

#     def self.create n
#       prepare_squared_nums 2 * n
#       (2..n).to_a.permutation.map do |xs|
#         new [Piece.new(1), *xs.map { |x| Piece.new x }]
#       end
#     end

#     def valid?
#       [*pieces, pieces.first].each_cons(2).all? do |pair|
#         squared? pair.map(&:berry_count).inject(:+)
#       end
#     end
#   end
# end

module Q18
  module_function

  def squared_nums
    @squared_nums ||= Set.new [1]
  end

  def prepare_squared_nums n
    ((Math.sqrt(squared_nums.max).floor + 1)..Math.sqrt(n).ceil).each do |i|
      squared_nums << (i * i)
    end
  end

  def squared? n
    squared_nums.include? n
  end

  def try_create n
    prepare_squared_nums 2 * n
    pieces = (1..n).to_a
    x = place [pieces.shift], pieces
  end

  def place pieces, left
    p pieces, left
    if left.empty?
      if squared?(pieces.first + pieces.last)
        [pieces]
      else
        []
      end
    else
      left.select { |p| squared?(pieces.last + p) }
        .map { |p| place [*pieces, p], (left - [p]) }
    end
  end

  def integers
    Enumerator.new do |y|
      i = 32
      loop do
        y << i
        i += 1
      end
    end
  end

  def run
    x = integers.find do |i|
      puts i
      try_create i
    end
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q18.run
  end
end

puts
puts "answer : #{$answer}"
