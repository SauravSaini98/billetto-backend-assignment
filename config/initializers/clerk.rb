require 'clerk'

Clerk.configure do |c|
  c.secret_key = ENV.fetch('CLERK_SECRET_KEY', 'dummy_secret_key_to_allow_rails_to_boot')
  c.publishable_key = ENV.fetch('CLERK_PUBLISHABLE_KEY', 'dummy_publishable_key')
  c.debug = true
end
