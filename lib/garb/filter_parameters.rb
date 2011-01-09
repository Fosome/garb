module Garb
  class FilterParameters
    def self.define_operators(*methods)
      methods.each do |method|
        class_eval <<-CODE
          def #{method}(field, value)
            @filter_hash.merge!({SymbolOperator.new(field, :#{method}) => value})
          end
        CODE
      end
    end

    define_operators :eql, :not_eql, :gt, :gte, :lt, :lte, :matches,
      :does_not_match, :contains, :does_not_contain, :substring, :not_substring

    attr_accessor :parameters

    def initialize
      self.parameters = []
    end

    def filters(&block)
      @filter_hash = {}

      instance_eval &block

      self.parameters << @filter_hash
    end

    def to_params
      value = self.parameters.map do |param|
        param.map do |k,v|
          next unless k.is_a?(SymbolOperator)
          escaped_v = v.to_s.gsub(/([,;\\])/) {|c| '\\'+c}
          "#{URI.encode(k.to_google_analytics, /[=<>]/)}#{CGI::escape(escaped_v)}"
        end.join('%3B') # Hash AND (no duplicate keys), escape char for ';' fixes oauth
      end.join(',') # Array OR

      value.empty? ? {} : {'filters' => value}
    end
  end
end
