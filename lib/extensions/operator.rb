# Concept from dm-core
class Operator
  attr_reader :target, :operator, :prefix
  
  def initialize(target, operator, prefix=false)
    @target   = target.to_ga
    @operator = operator
    @prefix = prefix
  end
  
  def to_ga
    @prefix ? "#{operator}#{target}" : "#{target}#{operator}"
  end
  
  def ==(rhs)
    target == rhs.target &&
    operator == rhs.operator &&
    prefix == rhs.prefix
  end
end
