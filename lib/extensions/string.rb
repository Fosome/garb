class String
  def underscored
    self.gsub(/([A-Z])/, '_\1').downcase
  end
  
  def lower_camelized
    self.gsub(/(_)(.)/) { $2.upcase }
  end
  
  def to_ga
    "ga:#{self}"
  end

  def from_ga
    self.gsub(/^ga\:/, '')
  end
end
