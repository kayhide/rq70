require 'benchmark'
require 'pry'

module Q24
  module_function

  def candidates
    @candidates ||=
      begin
        singles = (1..9).map { |i| [i] }
        a = [1, 2, 3, 6, 9, 8, 7, 4]
        doubles = a.zip(a.rotate)
        singles + doubles
      end
  end

  def candidates_
    @candidates ||=
      begin
        singles = (1..3).map { |i| [i] }
        doubles = [[1, 2], [2, 3]]
        singles + doubles
      end
  end

  def combinations shots, candidates
    if candidates.empty?
      completed?(shots) ? [shots] : []
    else
      shot = candidates.first
      combinations([*shots, shot], except(candidates.drop(1), shot)) +
        combinations(shots, candidates.drop(1))
    end
  end

  def except shots, ns
    ns.inject(shots) do |acc, elem|
      acc.reject { |s| s.include? elem }
    end
  end

  def completed? shots
    shots.flatten.uniq.count == candidates.flatten.uniq.count
  end

  def run
    res = combinations [], candidates
    n = res.group_by(&:count).map do |k, v|
      v.count * (1..k).inject(:*)
    end.inject(:+)
    n
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q24.run
  end
end

puts
puts "answer : #{$answer}"
