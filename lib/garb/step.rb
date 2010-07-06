module Garb
  class Step
    attr_reader :name, :number, :path

    def initialize(attributes)
      return unless attributes.is_a?(Hash)

      @name = attributes['name']
      @number = attributes['number'].to_i
      @path = attributes['path']
    end
  end
end
