require 'benchmark'
require 'pry'
require 'set'

class Array
  def sum
    inject(:+)
  end
end

module Q26
  module_function

  # SIZE = [3, 2]
  SIZE = [10, 10]
  GOAL_POSITION = [SIZE[0] - 1, SIZE[1] - 1]

  module Motions
    EAST = [1, 0]
    NORTH = [0, -1]
    WEST = [-1, 0]
    SOUTH = [0, 1]
    ALL = [EAST, NORTH, WEST, SOUTH]
  end

  class Board < Struct.new :car_position, :void_position
    def move_void motion
      new_void_position = void_position.zip(motion).map(&:sum)
      new_car_position = (car_position == new_void_position) ? void_position : car_position
      Board.new new_car_position, new_void_position
    end

    def valid?
      void_position.zip(SIZE).all? { |x, max| (0...max).include? x }
    end

    def goaled?
      car_position == GOAL_POSITION
    end
  end

  def initial_board
    Board.new [0, 0], GOAL_POSITION
  end

  def push history, board
    unless @cache.include? board
      @cache << board
      @queue << [*history, board]
    end
  end

  def solve
    while !@queue.first.last.goaled?
      history = @queue.shift
      board = history.last
      Motions::ALL.map { |motion| board.move_void motion }
                  .select(&:valid?)
                  .each { |b| push history, b }
    end
    @queue.first
  end

  def run
    @cache = Set.new
    @queue = []
    push [], initial_board
    res = solve
    res.count - 1
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q26.run
  end
end

puts
puts "answer : #{$answer}"
