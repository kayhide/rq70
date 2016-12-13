require 'benchmark'
require 'pry'
require 'set'
require 'builder'

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
    @res = solve
    @res.count - 1
  end

  def output_svg
    Exporter.new.export @res, 'result.svg'
  end

  class Exporter
    def initialize options = {}
      @width = options.fetch :width, 600
      @height = @width * SIZE[1] / SIZE[0]
      @interval = @width / SIZE[0]
    end

    def export history, file
      open(file, 'w') { |io| io << svg(history) }
    end

    def svg history
      a = @interval
      b = Builder::XmlMarkup.new
      b.declare! :DOCTYPE, :svg,
                 :PUBLIC, "-//W3C//DTD SVG 1.1//EN",
                 "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
      b.svg(
        version: '1.1',
        xmlns: 'http://www.w3.org/2000/svg',
        x: 0, y: 0, width: @width, height: @height,
        view_box: [0, 0, @width, @height].join(' ')
      ) do
        b.rect(fill:'white', x: 0, y: 0, width: @width, height: @height)
        b.pattern(id: 'checkerboard', patternUnits: 'userSpaceOnUse',
                  x: 0, y: 0, width: 2 * a, height: 2 * a) do
          b.rect(fill: 'rgba(44, 204, 208, 0.2)', x: 0, y: 0, width: a, height: a)
          b.rect(fill: 'rgba(44, 204, 208, 0.2)', x: a, y: a, width: a, height: a)
        end
        b.rect(fill:'url(#checkerboard)', x: 0, y: 0, width: @width, height: @height)
        animating_circle(b, history.map(&:car_position), 'lightcoral')
        animating_circle(b, history.map(&:void_position), 'rgba(128, 128, 128, 0.5)')
      end
    end

    def from_position pos
      pos.map { |x| (x * @interval + @interval / 2).to_s }
    end

    def animating_circle builder, positions, color
      r = @interval * 0.4
      xs, ys = positions.map { |pos| from_position pos }.transpose
      dur = positions.length * 0.1
      b = builder
      b.circle(r: r, fill: color) do
        b.animate(attributeName: 'cx', values: xs.join(';'), dur: dur, fill: 'freeze')
        b.animate(attributeName: 'cy', values: ys.join(';'), dur: dur, fill: 'freeze')
      end
    end
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q26.run
  end
end

puts
puts "answer : #{$answer}"

Q26.output_svg
