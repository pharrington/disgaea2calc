# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_disgaea2calc_session',
  :secret      => 'bf349a84205af5341eaa0f92d9467ea3c9c3e310ba48d8678475ee2b31f1e9fd16b0c605ff56b69e0be2d588dca540d51ecf5ba8fa6ef2a801e6a19046fffea0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
