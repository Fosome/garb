class SymbolOperator
  def initialize(field, operator)
    @field, @operator = field, operator
  end unless method_defined?(:initialize)

  def to_google_analytics
    operators = {
      :eql => '==',
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
      :not_substring => '!@',
      :desc => '-',
      :descending => '-'
    }

    target = Garb.to_google_analytics(@field)
    operator = operators[@operator]

    [:desc, :descending].include?(@operator) ? "#{operator}#{target}" : "#{target}#{operator}"
  end
end

class Symbol
  [:eql, :not_eql, :gt, :gte, :lt, :lte, :desc, :descending,
    :matches, :does_not_match, :contains, :does_not_contain,
    :substring, :not_substring].each do |operator|

    define_method(operator) do
      SymbolOperator.new(self, operator)
    end unless method_defined?(operator)
  end
end
