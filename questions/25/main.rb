require 'benchmark'
require 'pry'

module Q25
  module_function

  COUNT = 6

  def patterns
    ns = (1..(COUNT-1)).to_a.permutation.to_a
    ns.product(ns).map do |xs, ys|
      xs = [0, *xs.zip(xs).inject(:+)]
      ys = [*ys.zip(ys).inject(:+), 0]
      xs.zip ys
    end
  end

  def count_crossings pattern
    pattern.combination(2).count { |x, y| crossing? x, y }
  end

  def crossing? x, y
    (x.first - y.first) * (x.last - y.last) < 0
  end

  def run
    xs = patterns.map { |p| [count_crossings(p), p] }
    x = xs.max_by(&:first)
    x
  end

  class Exporter
    def initialize options = {}
      @width = options.fetch :width, 100
      @height = options.fetch :height, 100
      @interval = @height / (COUNT - 1)
      @offset = options.fetch :offset, 5
    end

    def export pattern, file
      open(file, 'w') { |io| io << <<~EOS }
      <html>
      <body>
      <svg viewBox="#{-@offset} #{-@offset} #{@width + 2*@offset} #{@height + 2*@offset}">
      <path stroke="black" stroke-width="1" fill="none" d="#{svg_path pattern}" />
      </svg>
      </body>
      </html>
      EOS
    end

    def svg_path pattern
      pattern.map do |p|
        [
          "M #{@offset} #{p.first * @interval}",
          "L #{@width} #{p.last * @interval}"
        ]
      end.flatten.join(" ")
    end
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q25.run
  end
end

puts
puts "answer : #{$answer}"
