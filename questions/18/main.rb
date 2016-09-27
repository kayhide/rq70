require 'benchmark'
require 'pry'
require 'set'

module Q18_
  module_function

  class Piece < Struct.new :berry_count
  end

  class Whole < Struct.new :pieces
    def self.squared_nums
      @squared_nums ||= Set.new [1]
    end

    def self.prepare_squared_nums n
      ((Math.sqrt(squared_nums.max).floor + 1)..Math.sqrt(n).ceil).each do |i|
        squared_nums << (i * i)
      end
    end

    def self.create n
      prepare_squared_nums 2 * n
      (2..n).to_a.permutation.map do |xs|
        new [Piece.new(1), *xs.map { |x| Piece.new x }]
      end
    end

    def valid?
      [*pieces, pieces.first].each_cons(2).all? do |pair|
        squared? pair.map(&:berry_count).inject(:+)
      end
    end
  end
end

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

  def squared? nums
    squared_nums.include? nums.inject(:+)
  end

  def try_create n
    prepare_squared_nums 2 * n
    place [1], (2..n).to_a
  end

  def place pieces, left
    if pieces.count < 2 || squared?(pieces.last(2))
      if left.empty?
        if squared?([pieces.first, pieces.last])
          [pieces]
        else
          []
        end
      else
        left.map { |p| place [*pieces, p], left - [p] }.inject(:+)
      end
    else
      []
    end
  end

  def integers
    (1..Float::INFINITY).lazy
  end

  def run
    res = integers
          .map { |i| try_create i }
          .drop_while(&:empty?)
          .first
    [res.first.count, res]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q18.run
  end
end

puts
puts "answer : #{$answer}"
