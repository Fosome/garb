module Garb
  class FilterParameters
    # def self.define_operators(*methods)
    #   methods.each do |method|
    #     class_eval <<-CODE
    #       def #{method}(field, value)
    #         @filter_hash.merge!({SymbolOperator.new(field, :#{method}) => value})
    #       end
    #     CODE
    #   end
    # end

    # define_operators :eql, :not_eql, :gt, :gte, :lt, :lte, :matches,
    #   :does_not_match, :contains, :does_not_contain, :substring, :not_substring

    attr_accessor :parameters

    def initialize(parameters)
      self.parameters = (Array.wrap(parameters) || []).compact
    end

    [{}, [{}, {}]]
    def to_params
      value = array_to_params(self.parameters)

      value.empty? ? {} : {'filters' => value}
    end

    private
    def array_to_params(arr)
      arr.map do |param|
        param.is_a?(Hash) ? hash_to_params(param) : array_to_params(param)
      end.join(',') # Array OR
    end

    def hash_to_params(hsh)
      hsh.map do |k,v|
        next unless k.is_a?(SymbolOperatorMethods)

        escaped_v = v.to_s.gsub(/([,;\\])/) {|c| '\\'+c}
        "#{URI.encode(k.to_google_analytics, /[=<>]/)}#{CGI::escape(escaped_v)}"
      end.join('%3B') # Hash AND (no duplicate keys), escape char for ';' fixes oauth
    end
  end
end
