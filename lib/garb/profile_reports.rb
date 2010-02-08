module Garb
  module ProfileReports
    def self.add_report_method(klass)
      # demodulize leaves potential to redefine
      # these methods given different namespaces
      method_name = klass.to_s.demodulize.underscore

      class_eval <<-CODE
        def #{method_name}(opts = {}, &block)
          #{klass}.results(self, opts, &block)
        end
      CODE
    end
  end
end
