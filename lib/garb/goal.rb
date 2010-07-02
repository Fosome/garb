module Garb
  class Goal
    attr_reader :name, :number, :value

    def initialize(attributes={})
      return unless attributes.is_a?(Hash)

      @name = attributes['name']
      @number = attributes['number'].to_i
      @value = attributes['value'].to_f
      @active = (attributes['active'] == 'true')
    end

    def active?
      @active
    end
  end
end
