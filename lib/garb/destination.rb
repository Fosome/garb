module Garb
  class Destination
    attr_reader :match_type, :expression, :steps, :case_sensitive

    alias :case_sensitive? :case_sensitive

    def initialize(attributes)
      return unless attributes.is_a?(Hash)

      @match_type = attributes['matchType']
      @expression = attributes['expression']
      @case_sensitive = (attributes['caseSensitive'] == 'true')

      step_attributes = attributes[Garb.to_ga('step')]
      @steps = Array(step_attributes.is_a?(Hash) ? [step_attributes] : step_attributes).map {|s| Step.new(s)}
    end
  end
end
