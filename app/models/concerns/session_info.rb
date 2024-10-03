module SessionInfo
  def session
    Thread.current[:session] || {}
  end

  def self.session= session
    Thread.current[:session] = session
  end
end
