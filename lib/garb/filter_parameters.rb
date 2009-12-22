module Garb
  class FilterParameters
    def self.define_operator(key, operation)
      class_eval <<-CODE
        def #{key}(target, value)
          self.parameters << {Operator.new(target, '#{operation}') => value}
        end
      CODE
    end

    define_operator(:eql, '==')
    define_operator(:not_eql, '!=')
    define_operator(:gt, '>')
    define_operator(:gte, '>=')
    define_operator(:lt, '<')
    define_operator(:lte, '<=')
    define_operator(:matches, '==')
    define_operator(:does_not_match, '!=')
    define_operator(:contains, '=~')
    define_operator(:does_not_contain, '!~')
    define_operator(:substring, '=@')
    define_operator(:not_substring, '!@')

    attr_accessor :parameters

    def initialize
      self.parameters = []
    end

    def filters(&block)
      instance_eval &block
    end

    def to_params
      value = self.parameters.map do |param|
        param.map do |k,v|
          next unless k.is_a?(Garb::Operator)
          "#{k.target}#{URI.encode(k.operator.to_s, /[=<>]/)}#{CGI::escape(v.to_s)}"
        end.join(',') # Hash AND
      end.join(';') # Array OR

      value.empty? ? {} : {'filters' => value}
    end
  end
end
