# Concept from dm-core
class Operator
  attr_reader :target, :operator, :prefix
  
  def initialize(target, operator, prefix=false)
    @target   = target.to_ga.lower_camelized
    @operator = operator
    @prefix = prefix
  end
  
  def to_s
    @prefix ? "#{operator}#{target}" : "#{target}#{operator}"
  end
  
  def ==(rhs)
    target == rhs.target &&
    operator == rhs.operator &&
    prefix == rhs.prefix
  end
end
