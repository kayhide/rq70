require 'benchmark'
require 'pry'

module Q14
  module_function

  COUNTRIES = %w(
    Brazil
    Cameroon
    Chile
    Greece
    Uruguay
    Italy
    France
    Bosnia_and_Herzegovina
    Germany
    USA
    Russia
    Croatia
    Spain
    Australia
    Cote_d'Ivoire
    Costa_Rica
    Switzerland
    Honduras
    Iran
    Portugal
    Belgium
    Korea_Republic
    Mexico
    Netherlands
    Colombia
    Japan
    England
    Ecuador
    Argentina
    Nigeria
    Ghana
    Algeria
  )

  def next_candidates word, words
    if word
      words.select { |w| w.start_with? word[-1] }
    else
      words
    end
  end

  def chains chain, words
    candidates = next_candidates(chain.last, words)
    if candidates.empty?
      [chain]
    else
      candidates.map do |w| 
        chains [*chain, w], words - [w]
      end.inject(:+)
    end
  end

  def run
    longest = chains([], COUNTRIES.map(&:downcase)).max_by(&:length)
    [longest.length, longest]
  end
end

Benchmark.bm do |x|
  x.report do
    $answer = Q14.run
  end
end

puts
puts "answer : #{$answer}"
