class String
  def to_google_analytics
    "ga:#{self}"
  end

  def from_google_analytics
    self.gsub(/^ga\:/, '')
  end
end
