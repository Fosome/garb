# Pull in some AS String utilities (not loaded if AS is available)
unless Object.const_defined?("ActiveSupport")
  class String
    def camelize(first_letter = :upper)
      case first_letter
        when :upper then ActiveSupport::Inflector.camelize(self, true)
        when :lower then ActiveSupport::Inflector.camelize(self, false)
      end
    end
    alias_method :camelcase, :camelize

    def underscore
      ActiveSupport::Inflector.underscore(self)
    end

    def demodulize
      ActiveSupport::Inflector.demodulize(self)
    end
  end


  module ActiveSupport
    module Inflector
      extend self

      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end
   
      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

      def demodulize(class_name_in_module)
        class_name_in_module.to_s.gsub(/^.*::/, '')
      end
    end
  end
end
