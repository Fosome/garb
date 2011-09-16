unless Object.const_defined?("ActiveSupport")
  puts "Array extension."
  class Array
    def self.wrap(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary
      else
        [object]
      end
    end
  end
else
  puts "ActiveSupport is suddenly defined!"
end
