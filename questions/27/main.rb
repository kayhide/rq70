require 'benchmark'
require 'pry'

module Q27
  module_function

  # SIZE = [3, 2]
  SIZE = [6, 4]
  WIDTH_RANGE = (0..SIZE[0])
  HEIGHT_RANGE = (0..SIZE[1])

  class Point < Struct.new(:x, :y)
    def add dx, dy
      Point.new x + dx, y + dy
    end

    def inside?
      WIDTH_RANGE.include?(x) && HEIGHT_RANGE.include?(y)
    end

    def goaled?
      x == SIZE[0] && y == SIZE[1]
    end
  end

  class Path < Array
    def nexts
      p0, p1 = last(2)
      case [p1.x - p0.x, p1.y - p0.y]
      when [1, 0]
        [p1.add(1, 0), p1.add(0, 1)]
      when [0, 1]
        [p1.add(0, 1), p1.add(-1, 0)]
      when [-1, 0]
        [p1.add(-1, 0), p1.add(0, -1)]
      when [0, -1]
        [p1.add(0, -1), p1.add(1, 0)]
      end.select { |p| acceptable? p }
    end

    def acceptable? p
      p.inside? &&
        each_cons(2).none? do |p0, p1|
        (p0 == last && p1 == p) ||
          (p1 == last && p0 == p)
      end
    end

    def snoc p
      Path.new(self) << p
    end
  end

  def move path
    if path.last.goaled?
      [path]
    else
      path.nexts
          .map { |p| move path.snoc(p) }
          .inject([], :+)
    end
  end

  def run
    path = Path.new [Point.new(0, 0), Point.new(1, 0)]
    res = move path
    res.count
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q27.run
  end
end

puts
puts "answer : #{$answer}"
