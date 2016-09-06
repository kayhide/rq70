require 'pry'
require 'benchmark'

module Q15_
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

module Q15
  module_function

  STAIRS_COUNT = 10
  MAX_STEP = 4
  INITIAL_PATTERN = [1] + [0] * (STAIRS_COUNT)

  def proceed pattern
    new_pattern = [0] * (STAIRS_COUNT + 1)
    pattern.each_with_index do |orig, i|
      ((i + 1)..[i + MAX_STEP, STAIRS_COUNT].min).each do |x|
        new_pattern[x] += orig
      end
    end
    new_pattern
  end

  def run
    all_patterns = STAIRS_COUNT.times.inject([INITIAL_PATTERN]) do |patterns|
      [*patterns, proceed(patterns.last)]
    end
    all_patterns.each_slice(2).map(&:first).map(&:last).inject(:+)
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q15.run
  end
end

puts
puts "answer : #{$answer}"
