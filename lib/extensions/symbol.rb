class Symbol
  # OPERATORS

  # Sorting
  def desc
    Operator.new(self, '-', true)
  end

  # Metric filters
  def eql
    Operator.new(self, "==")
  end
  
  def not_eql
    Operator.new(self, "!=")
  end

  def gt
    Operator.new(self, ">")
  end

  def lt
    Operator.new(self, "<")
  end

  def gte
    Operator.new(self, ">=")
  end

  def lte
    Operator.new(self, "<=")
  end

  # Dimension filters
  def matches
    Operator.new(self, "==")
  end

  def does_not_match
    Operator.new(self, "!=")
  end

  def contains
    Operator.new(self, "=~")
  end

  def does_not_contain
    Operator.new(self, "!~")
  end

  def substring
    Operator.new(self, "=@")
  end

  def not_substring
    Operator.new(self, "!@")
  end
  
  def to_ga
    "ga:#{self}"
  end
end