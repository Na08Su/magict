
Devise.setup do |config|

  config.mailer_sender = 'natsuki @ luxiar <noreply@example.com>'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  require 'omniauth-facebook'
  config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']

  require 'omniauth-github'
  config.omniauth :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], scope: 'user:email'

end
