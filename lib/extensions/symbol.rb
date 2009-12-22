class Symbol
  # OPERATORS

  def self.operator(operators)
    operators.each do |method, operator|
      class_eval <<-CODE
        def #{method}
          Garb::Operator.new(self, '#{operator}')
        end
      CODE
    end
  end

  # Sorting
  def desc
    Garb::Operator.new(self, '-', true)
  end

  operator  :eql => '==',
            :not_eql => '!=',
            :gt => '>',
            :gte => '>=',
            :lt => '<',
            :lte => '<=',
            :matches => '==',
            :does_not_match => '!=',
            :contains => '=~',
            :does_not_contain => '!~',
            :substring => '=@',
            :not_substring => '!@'

  # Metric filters  
  def to_ga
    self.to_s.camelize(:lower).to_ga
  end
end
