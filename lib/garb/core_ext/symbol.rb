module SymbolOperatorMethods
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

    t = Garb.to_google_analytics(@field || @target)
    o = operators[@operator]

    [:desc, :descending].include?(@operator) ? "#{o}#{t}" : "#{t}#{o}"
  end
end

class SymbolOperator
  def initialize(field, operator)
    @field, @operator = field, operator
  end unless method_defined?(:initialize)

  include SymbolOperatorMethods
end

symbol_slugs = []

if Object.const_defined?("DataMapper")
  # make sure the class is defined
  require 'dm-core/core_ext/symbol'

  # add to_google_analytics to DM's Opeartor
  class DataMapper::Query::Operator
    include SymbolOperatorMethods
  end

  symbol_slugs = (Garb.symbol_operator_slugs - DataMapper::Query::Conditions::Comparison.slugs)
else
  symbol_slugs = Garb.symbol_operator_slugs
end

# define the remaining symbol operators
symbol_slugs.each do |operator|
  Symbol.class_eval <<-RUBY
    def #{operator}
      warn("The use of SymbolOperator(#{operator}, etc.) has been deprecated. Please use named filters.")
      SymbolOperator.new(self, :#{operator})
    end unless method_defined?(:#{operator})
  RUBY
end
