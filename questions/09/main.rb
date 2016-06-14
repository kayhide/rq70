require 'benchmark'
require 'pry'

module Q09
  MALE = 20
  FEMALE = 10
  # MALE = 6
  # FEMALE = 3

  module_function

  def patterns states
    if done? states.last
      [states]
    elsif valid? states.last
      patterns(states + [[states.last[0] + 1, states.last[1]]]) +
        patterns(states + [[states.last[0], states.last[1] + 1]])
    else
      []
    end
  end

  def valid? state
    (state == [0, 0]) ||
      (
        (state[0] <= MALE) && (state[1] <= FEMALE) &&
        (state[0] != state[1]) && (MALE - state[0] != FEMALE - state[1])
      )
  end

  def done? state
    state == [MALE, FEMALE]
  end

  def count states
    if done? states.last
      1
    elsif valid? states.last
      count(states + [[states.last[0] + 1, states.last[1]]]) +
        count(states + [[states.last[0], states.last[1] + 1]])
    else
      0
    end
  end


  def run
    # patterns([[0, 0]]).count
    count([[0, 0]])
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q09.run
  end
end

puts
puts "answer : #{$answer}"
