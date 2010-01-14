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
      value = self.elements.map{|param| Garb.to_google_analytics(param)}.join(',')
      value.empty? ? {} : {self.name => value}
    end
  end
end
