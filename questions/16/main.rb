require 'pry'
require 'benchmark'

module Q16
  module_function

  LENGTHS = (1..500).to_a

  class Cord < Struct.new(:length)
    def valid?
      length % 4 == 0
    end

    def quarter
      length / 4
    end

    def square_area
      @square_area ||= quarter**2
    end

    def rectangles
      (1..(quarter - 1)).map do |len|
        Rectangle.new len, (length / 2 - len)
      end
    end

    def rectangle_combinations
      rectangles.combination(2)
        .select { |rs| rs.map(&:area).inject(:+) == square_area }
        .map { |rs| Combination.new self, rs }
    end
  end

  class Rectangle < Struct.new(:short, :long)
    def area
      @area ||= short * long
    end

    def length
      @length ||= (short + long) * 2
    end
  end

  class Combination < Struct.new(:cord, :rectangles)
    def regularized_areas
      rectangles.map { |rect| rect.area / cord.square_area.to_f }
    end
  end

  def run
    combinations = LENGTHS
                   .map { |len| Cord.new len }
                   .select(&:valid?)
                   .map(&:rectangle_combinations)
                   .inject(:+)
                   .uniq(&:regularized_areas)
    combinations.count
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q16.run
  end
end

puts
puts "answer : #{$answer}"
