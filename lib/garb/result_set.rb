module Garb
  class ResultSet
    include Enumerable

    attr_accessor :total_results, :sampled

    alias :sampled? :sampled

    def initialize(results)
      @results = results
    end

    def each(&block)
      @results.each(&block)
    end

    def to_a
      @results
    end
  end
end
