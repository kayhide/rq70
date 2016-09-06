require 'pry'
require 'benchmark'

module Q15
  module_function

  class State < Struct.new :lo, :hi
    def met?
      lo == hi
    end

    def passed?
      lo > hi
    end

    def move up, down
      State.new lo + up, hi - down
    end

    def inspect
      "(#{lo}, #{hi})"
    end
  end

  STAIRS_COUNT = 10
  INITIAL_STATE = State.new(0, STAIRS_COUNT)
  MAX_STEP = 4

  def step_combinations
    @step_conbinations ||=
      begin
        variations = (1..MAX_STEP).to_a
        variations.product(variations)
      end
  end

  def proceed states
    last = states.last
    if last.met?
      [states]
    elsif last.passed?
      []
    else
      step_combinations.map do |steps|
        proceed [*states, last.move(*steps)]
      end.inject(:+)
    end
  end

  def run
    proceed([INITIAL_STATE]).count
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q15.run
  end
end

puts
puts "answer : #{$answer}"
