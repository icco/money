##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  set :session_secret, ENV['SESSION_SECRET'] || '080e5c0c277e05d05d2867a08e82798b0ba0b3d037dcb6e'
end

# Mounts the core application for this project
Padrino.mount("MoneyApp").to('/')
