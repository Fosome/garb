unless Object.const_defined?("ActiveSupport")
  require File.expand_path("core_ext/string", File.dirname(__FILE__))
  require File.expand_path("core_ext/array", File.dirname(__FILE__))
end

require File.expand_path("core_ext/symbol", File.dirname(__FILE__))