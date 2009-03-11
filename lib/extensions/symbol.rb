class Symbol
  # OPERATORS

  def self.operator(operators)
    operators.each do |method, operator|
      class_eval <<-CODE
        def #{method}
          Operator.new(self, '#{operator}')
        end
      CODE
    end
  end

  # Sorting
  def desc
    Operator.new(self, '-', true)
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
    "ga:#{self.to_s.lower_camelized}"
  end
end