# Helper methods defined here can be accessed in any controller or view in the application

Money.helpers do
  def isDev?
    return Money.isDev?
  end

  def isProd?
    return Money.isProd?
  end

  def isLoggedIn?
    return session[:show] || isDev?
  end
end
