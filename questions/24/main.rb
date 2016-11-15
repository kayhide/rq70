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

  def panel_count
    @panel_count ||= candidates.flatten.uniq.count
  end

  def combinations shots, candidates
    if candidates.empty?
      completed?(shots) ? [shots] : []
    else
      shot = candidates.first
      next_candidates = candidates.drop(1)
      combinations([*shots, shot], except(next_candidates, shot)) +
        combinations(shots, next_candidates)
    end
  end

  def except shots, ns
    shots.reject { |s| (s & ns).any? }
  end

  def completed? shots
    shots.inject([], :+).count == panel_count
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
