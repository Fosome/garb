module Garb
  class ReportParameter

    attr_reader :elements
    
    def initialize(name)
      @name = name
      @elements = []
    end
    
    def name
      @name.to_s
    end
    
    def <<(element)
      (@elements += [element].flatten).compact!
      self
    end
    
    def to_params
      params = self.elements.map do |elem|
        case elem
        when Hash
          elem.collect do |k,v|
            next unless k.is_a?(Operator)
            "#{k.target}#{URI.encode(k.operator.to_s, /[=<>]/)}#{CGI::escape(v.to_s)}"
          end.join(';')
        else
          elem.to_ga
        end
      end.join(',')
      
      params.empty? ? {} : {self.name => params}
    end
  end
end