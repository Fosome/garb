# Concept from dm-core
module Garb
  class Operator
    attr_reader :target, :operator, :prefix
  
    def initialize(target, operator, prefix=false)
      @target   = Garb.to_google_analytics(target)
      @operator = operator
      @prefix = prefix
    end

    def to_google_analytics
      @prefix ? "#{operator}#{target}" : "#{target}#{operator}"
    end
  
    def ==(rhs)
      target == rhs.target &&
      operator == rhs.operator &&
      prefix == rhs.prefix
    end
  end
end
