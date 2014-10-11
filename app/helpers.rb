# Helper methods defined here can be accessed in any controller or view in the application
MoneyApp.helpers do
  def isDev?
    return MoneyApp.isDev?
  end

  def isProd?
    return MoneyApp.isProd?
  end

  def isLoggedIn?
    return session[:show] || isDev?
  end
end
