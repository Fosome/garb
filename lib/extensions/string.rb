class String
  def to_ga
    "ga:#{self}"
  end

  def from_ga
    self.gsub(/^ga\:/, '')
  end
end
